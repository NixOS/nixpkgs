{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  nix-update-script,
  pkg-config,
  openssl,
  versionCheckHook,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${finalAttrs.version}";
    hash = "sha256-JS2nRh3/MNQ0mfdr2/Q10sAB38yWBLpw2zFf0dJORuM=";
  };

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  cargoHash = "sha256-HbhOiTO7qFp64v+Bb62V1LxPH7qeTnWwkJKPEN4Vx6c=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [ gitMinimal ];

  __darwinAllowLocalNetworking = true;
  preCheck = ''
    # Disables sandbox tests which want to access /usr/bin/touch
    export CODEX_SANDBOX=seatbelt
    # Skips tests that require networking
    export CODEX_SANDBOX_NETWORK_DISABLED=1
    # Required by ui_snapshot_add_details and ui_snapshot_update_details_with_rename
    export TERM=dumb
    # Required by azure_overrides_assign_properties_used_for_responses_url and env_var_overrides_loaded_auth
    export USER=test
  '';
  checkFlags = [
    # Wants to access unix sockets
    "--skip=allow_unix_socketpair_recvfrom"
    # Needs access to python3. However, adding python3 to nativeCheckInputs doesn't resolve the issue
    "--skip=python_multiprocessing_lock_works_under_sandbox"
    # Version 0.0.0 hardcoded
    "--skip=test_conversation_create_and_send_message_ok"
    "--skip=test_send_message_session_not_found"
    "--skip=test_send_message_success"
    # Tests fail
    "--skip=diff_render::tests::ui_snapshot_add_details"
    "--skip=diff_render::tests::ui_snapshot_update_details_with_rename"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Wants to access /bin/zsh
    "--skip=shell::tests::test_run_with_profile_escaping_and_execution"
    # Requires access to the Apple system configuration
    "--skip=azure_overrides_assign_properties_used_for_responses_url"
    "--skip=env_var_overrides_loaded_auth"
    "--skip=includes_base_instructions_override_in_request"
    "--skip=includes_user_instructions_message_in_request"
    "--skip=originator_config_override_is_used"
    "--skip=per_turn_overrides_keep_cached_prefix_and_key_constant"
    "--skip=overrides_turn_context_but_keeps_cached_prefix_and_key_constant"
    "--skip=prefixes_context_and_instructions_once_and_consistently_across_requests"
    "--skip=test_apply_patch_tool"
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
