//
//  SignInViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SignInViewController: BaseViewController<SignInViewModel> {
    @IBOutlet private weak var emailTextFieldView: InputTextFieldView!
    @IBOutlet private weak var passwordTextFieldView: InputTextFieldView!
    @IBOutlet private weak var forgotButton: UIButton!
    @IBOutlet private weak var signInButton: BlackButton!
    
    weak var delegate: AuthenticationProtocol?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = SignInViewModel()
        viewModel.delegate = delegate
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        addCloseButton()
        title = "ControllerTitle.SignIn".localizable
        emailTextFieldView.placeholder = "Placeholder.Email".localizable.required.uppercased()
        passwordTextFieldView.placeholder = "Placeholder.Password".localizable.required.uppercased()
        forgotButton.setTitle("Button.Forgot".localizable, for: .normal)
        signInButton.setTitle("Button.SignIn".localizable.uppercased(), for: .normal)
    }
    
    private func setupViewModel() {
        emailTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        passwordTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)
        
        viewModel.emailErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                self?.emailTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        viewModel.passwordErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                self?.passwordTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .bind(to: viewModel.loginPressed)
            .disposed(by: disposeBag)
        
        viewModel.signInButtonEnabled
            .subscribe(onNext: { [weak self] enabled in
                self?.signInButton.isEnabled = enabled
            })
            .disposed(by: disposeBag)
        
        viewModel.signInSuccess.asObservable()
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
