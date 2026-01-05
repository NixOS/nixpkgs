{
  bash,
  fetchFromGitHub,
  gitMinimal,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  stdenvNoCC,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "code";
  version = "0.2.188";

  src = fetchFromGitHub {
    owner = "just-every";
    repo = "code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xUhgA4poybzFehVgVWHKx1ejhncvYAnug2oxLwGNrk0=";
  };

  sourceRoot = "${finalAttrs.src.name}/code-rs";

  postPatch = ''
    # shell::tests::test_run_with_profile_bash_escaping_and_execution
    substituteInPlace core/src/shell.rs \
      --replace-fail '"/bin/bash"' '"${lib.getExe bash}"'
  '';

  cargoHash = "sha256-wQHcwfBJE/qGXHgLDQ1NfBpgFdmQhuHCvfAG8KV+MHM=";

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    openssl
  ];

  CODE_VERSION = finalAttrs.version;

  cargoBuildFlags = [
    "--bin"
    "code"
    "--bin"
    "code-tui"
    "--bin"
    "code-exec"
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    # pty_error: No such file or directory (os error 2)
    "--skip=exec_command::session_manager::tests::session_manager_streams_and_truncates_from_now"
    "--skip=unified_exec::tests::multi_unified_exec_sessions"
    "--skip=unified_exec::tests::reusing_completed_session_returns_unknown_session"
    "--skip=unified_exec::tests::unified_exec_persists_across_requests_jif"
    "--skip=unified_exec::tests::unified_exec_timeouts"
  ];

  postInstall = ''
    ln -s $out/bin/code $out/bin/coder
  '';

  meta = {
    description = "Fast, effective, mind-blowing, coding CLI";
    homepage = "https://github.com/just-every/code";
    downloadPage = "https://github.com/just-every/code/releases";
    changelog = "https://github.com/just-every/code/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "code";
    priority = 10;
  };
})
