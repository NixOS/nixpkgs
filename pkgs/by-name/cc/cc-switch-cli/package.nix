{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  versionCheckHook,
  stdenv,
  installShellFiles,
  writableTmpDirAsHomeHook,
  lsof,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cc-switch-cli";
  version = "5.10.5";

  src = fetchFromGitHub {
    owner = "SaladDay";
    repo = "cc-switch-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RreuW2hlJFH2ETQPwUOB/DE3CtyK8+sEqjbb5cWbR0g=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  cargoHash = "sha256-OiK0PN1ILtMzl9+QndPnYa1PdFM2Y3BmE7MYJjAWnDc=";

  patches = [
    (fetchpatch2 {
      # already merged but not yet released
      # https://github.com/SaladDay/cc-switch-cli/pull/463
      name = "cc-switch-cli-skip-non-utf8-filename-test-on-macos";
      url = "https://github.com/SaladDay/cc-switch-cli/commit/1ae36f7ac66e3a837c064c8c3fb1c56449f3f7c1.patch?full_index=1";
      relative = "src-tauri";
      hash = "sha256-qMwAnjBsZZk8xwdlrVx/GpRW7DT+JNbONKxdK583xU4=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cc-switch \
      --bash <($out/bin/cc-switch completions bash) \
      --fish <($out/bin/cc-switch completions fish) \
      --zsh <($out/bin/cc-switch completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # rusqlite uses the "bundled" feature which compiles SQLite from source,
  # so no system sqlite dependency is needed.

  nativeCheckInputs = [
    writableTmpDirAsHomeHook # needs $HOME for many tests
    lsof # used in some tests
  ];

  # upstream defines a highly optimized release profile.
  # tests do not need the slow release build.
  checkType = "debug";

  # upstream runs tests single-threaded to prevent io race.
  dontUseCargoParallelTests = true;

  # needed for many tests in darwin's sandbox
  __darwinAllowLocalNetworking = true;

  cargoTestFlags = [
    # easier to diagnose test failures:
    "--no-fail-fast"

    # match the test targets run by upstream's CI:
    # https://github.com/SaladDay/cc-switch-cli/blob/main/.github/workflows/rust-ci.yml
    "--lib"
    "--bin=cc-switch"
    "--test=proxy_claude_forwarder_alignment"
    "--test=proxy_daemon"
    "--test=proxy_database"
  ];

  checkFlags = [
    # flaky: many database locks during tests make this slow and fail:
    "--skip=locked_main_database_degrades_within_the_overlay_busy_budget"

    # sandbox: access /bin/cat, not available in the nix sandbox
    "--skip=clipboard_command_writes_text_to_stdin_and_waits_for_success"

    # flaky: concurrency bug depends on the builder cores
    "--skip=parser_results_are_delivered_in_completion_order"
  ];

  meta = {
    description = "Cross-platform CLI management tool for Claude Code, Codex, Gemini, and OpenCode";
    homepage = "https://github.com/SaladDay/cc-switch-cli";
    changelog = "https://github.com/SaladDay/cc-switch-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bryango ];
    mainProgram = "cc-switch";
    platforms = lib.platforms.unix;
  };
})
