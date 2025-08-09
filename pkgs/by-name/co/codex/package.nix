{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  nix-update-script,
  pkg-config,
  python3,
  openssl,
  versionCheckHook,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${finalAttrs.version}";
    hash = "sha256-s7gN1fsk/PRiVVzlrtmAUd2Vu8hhKtlCesLOVrzJ/58=";
  };

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  cargoHash = "sha256-zgmiWyWB08v1WQVFzxpC/LGwF+XXbs8iW1d7i9Iw0Q4=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
    # Required because of codex-rs/login/src/login_with_chatgpt.py
    python3
  ];

  nativeCheckInputs = [ gitMinimal ];

  __darwinAllowLocalNetworking = true;
  env = {
    # Disables sandbox tests which want to access /usr/bin/touch
    CODEX_SANDBOX = "seatbelt";
    # Skips tests that require networking
    CODEX_SANDBOX_NETWORK_DISABLED = 1;
  };
  checkFlags = [
    # Wants to access /bin/zsh
    "--skip=shell::tests::test_run_with_profile_escaping_and_execution"
    # Fails with 'stream ended unexpectedly: InternalAgentDied'
    "--skip=includes_base_instructions_override_in_request"
    # Fails with 'stream ended unexpectedly: InternalAgentDied'
    "--skip=includes_user_instructions_message_in_request"
    # Fails with 'stream ended unexpectedly: InternalAgentDied'
    "--skip=originator_config_override_is_used"
    # Fails with 'called `Result::unwrap()` on an `Err` value: NotPresent'
    "--skip=azure_overrides_assign_properties_used_for_responses_url"
    # Fails with 'called `Result::unwrap()` on an `Err` value: NotPresent'
    "--skip=env_var_overrides_loaded_auth"
    # Version 0.0.0 hardcoded
    "--skip=test_conversation_create_and_send_message_ok"
    # Version 0.0.0 hardcoded
    "--skip=test_send_message_session_not_found"
    # Version 0.0.0 hardcoded
    "--skip=test_send_message_success"
  ];

  postInstall = lib.optionalString installShellCompletions ''
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^rust-v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    changelog = "https://raw.githubusercontent.com/openai/codex/refs/tags/rust-v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "codex";
    maintainers = with lib.maintainers; [
      malo
      delafthi
    ];
    platforms = lib.platforms.unix;
  };
})
