{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  udev,
  git,
  cacert,
  procps,
  python3,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sema";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "sema-lisp";
    repo = "sema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VTkmJOXXab0Pal90jFrGHTm6KdwzYqjAJsG4voWv4I8=";
  };

  cargoHash = "sha256-7Gdr+1/g16+/du4jhgYGFn7wKxCbTpbNXt88+qtx+x0=";

  cargoBuildFlags = [
    "-p"
    "sema-lang"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  nativeCheckInputs = [
    git
    cacert
    procps
    python3
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export USER=nixbld
  '';

  # PTY/terminal, interactive subprocess, TLS-cert-clearing, and global-state otel tests fail in the Nix build sandbox
  checkFlags = [
    "--skip=all_spans_are_on_disk_after_provider_shutdown"
    "--skip=cli_ctrlc_test::sigint_tears_down_parked_subprocess"
    "--skip=embedding_config_test::auto_configuration_honors_forced_openai_with_other_keys_present"
    "--skip=embedding_config_test::auto_configuration_uses_native_ollama_without_api_keys"
    "--skip=embedding_config_test::cli_overrides_environment_for_embedding_and_rerank_independently"
    "--skip=embedding_config_test::invalid_environment_selection_fails_before_running_the_program"
    "--skip=embedding_config_test::new_embedding_presets_auto_configure_from_environment"
    "--skip=embedding_config_test::partial_accounts_do_not_change_existing_automatic_selection"
    "--skip=file_exporter_writes_one_json_line_per_span"
    "--skip=git::tests::current_branch_non_empty"
    "--skip=git::tests::ignore_matches_target_but_not_cargo_toml"
    "--skip=git::tests::root_is_ancestor_of_cwd"
    "--skip=git::tests::status_returns_list"
    "--skip=handlers::command::tests::cancellation_kills_and_reaps_the_owned_child"
    "--skip=handlers::command::tests::timeout_kills_and_reaps_the_owned_child"
    "--skip=nomic_test::nomic_auto_configuration_uses_key_and_endpoint_override"
    "--skip=proc_pty_async_test::"
    "--skip=proc_run_tty_test::"
    "--skip=runtime_conformance_test::unified_runtime_purged_legacy_symbols_absent"
    "--skip=runtime_conformance_test::unified_runtime_scanner_detects_raw_blocking_recv_fixture"
    "--skip=shell_concurrent_test::shell_concurrent_overlap"
    "--skip=stream_file_async_test::cancelled_eval_stdin_read_does_not_steal_the_next_repl_line"
    "--skip=stream_file_async_test::cancelling_line_read_settles_before_worker_completion_and_reaps_later"
    "--skip=stream_file_async_test::cursor_position_query_with_partial_reply_remains_cancellable"
    "--skip=stream_file_async_test::kitty_support_query_with_partial_reply_remains_cancellable"
    "--skip=stream_file_async_test::terminal_query_requeues_unrelated_events_before_its_partial_suffix"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Lisp dialect with first-class LLM primitives";
    homepage = "https://sema-lang.com";
    changelog = "https://github.com/sema-lisp/sema/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ crimeminister ];
    platforms = lib.platforms.unix;
    mainProgram = "sema";
  };
})
