{
  lib,
<<<<<<< HEAD
  bash,
  replaceVars,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  rust-jemalloc-sys,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
<<<<<<< HEAD
  version = "0.46.1";
=======
  version = "0.43.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-BMGTUoIkDUaM1Ox+U8rquqZ822qB2oGuk7/5b1EnX2I=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-mXJuZXf5zcxarC+ftT2W15+yvC7gt7rocoCMq00v9a0=";
=======
    hash = "sha256-KVeuDK5f0VIMnhAMJvGMJ08tHOuuIBDPrTqO1YjsHXI=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-Cc3bLBP9SxMbXQmJJVIfItOzy0iUkxLMgk4fbzNP1yw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  buildInputs = [ rust-jemalloc-sys ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

<<<<<<< HEAD
  patches = [
    (replaceVars ./fix-shebang.patch { bash = lib.getExe bash; })
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # redirect tests writing to /tmp
  preCheck = ''
    export TMPDIR=$(mktemp -d)
  '';

<<<<<<< HEAD
=======
  checkFlags = [
    # FIX: tracking on https://github.com/facebook/pyrefly/issues/1667
    "--skip=test::lsp::lsp_interaction::configuration::test_pythonpath_change"
    "--skip=test::lsp::lsp_interaction::configuration::test_workspace_pythonpath_ignored_when_set_in_config_file"
    "--skip=test::lsp::lsp_interaction::notebook_sync::test_notebook_publish_diagnostics"
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # requires unstable rust features
  env.RUSTC_BOOTSTRAP = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast type checker and IDE for Python";
    homepage = "https://github.com/facebook/pyrefly";
    license = lib.licenses.mit;
    mainProgram = "pyrefly";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      cybardev
      QuiNzX
    ];
  };
})
