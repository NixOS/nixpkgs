{
<<<<<<< HEAD
  fetchFromGitHub,
  lib,
  nix-update-script,
=======
  bash,
  fetchFromGitHub,
  gitMinimal,
  lib,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  openssl,
  pkg-config,
  rustPlatform,
  stdenvNoCC,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "code";
<<<<<<< HEAD
  version = "0.6.5";
=======
  version = "0.2.188";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "just-every";
    repo = "code";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-X+YwTXla6EePXLhMgokiZkgkm9P/rkl2+2XC27tqAEk=";
=======
    hash = "sha256-xUhgA4poybzFehVgVWHKx1ejhncvYAnug2oxLwGNrk0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  sourceRoot = "${finalAttrs.src.name}/code-rs";

<<<<<<< HEAD
  cargoHash = "sha256-oNrBwI0klqQtGTMhPzVvOqMqvdexEVkZpLD6ssXqQX8=";
=======
  postPatch = ''
    # shell::tests::test_run_with_profile_bash_escaping_and_execution
    substituteInPlace core/src/shell.rs \
      --replace-fail '"/bin/bash"' '"${lib.getExe bash}"'
  '';

  cargoHash = "sha256-wQHcwfBJE/qGXHgLDQ1NfBpgFdmQhuHCvfAG8KV+MHM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  # Takes too much time
  doCheck = false;

  postInstall = ''
    ln -s $out/bin/code $out/bin/coder
  '';
=======
  nativeCheckInputs = [
    gitMinimal
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    mainProgram = "coder";
=======
    mainProgram = "code";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    priority = 10;
  };
})
