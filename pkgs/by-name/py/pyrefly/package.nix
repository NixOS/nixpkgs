{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  rust-jemalloc-sys,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.43.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-KVeuDK5f0VIMnhAMJvGMJ08tHOuuIBDPrTqO1YjsHXI=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-Cc3bLBP9SxMbXQmJJVIfItOzy0iUkxLMgk4fbzNP1yw=";

  buildInputs = [ rust-jemalloc-sys ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # redirect tests writing to /tmp
  preCheck = ''
    export TMPDIR=$(mktemp -d)
  '';

  checkFlags = [
    # FIX: tracking on https://github.com/facebook/pyrefly/issues/1667
    "--skip=test::lsp::lsp_interaction::configuration::test_pythonpath_change"
    "--skip=test::lsp::lsp_interaction::configuration::test_workspace_pythonpath_ignored_when_set_in_config_file"
  ];

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
