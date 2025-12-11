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
  version = "0.44.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-d0aZQkCt2Yypj2CSav585M6TuoUEwPXpz1oKLjFo6NI=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-gXKLzD5JbG62pc0pW5sRQJvBwr1ftu/ZOOXsQ7ZdWIU=";

  buildInputs = [ rust-jemalloc-sys ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # redirect tests writing to /tmp
  preCheck = ''
    export TMPDIR=$(mktemp -d)
  '';

  checkFlags = [
    # FIX: tracking on https://github.com/facebook/pyrefly/issues/1667
    "--skip=test::lsp::lsp_interaction::configuration::test_pythonpath_change"
    "--skip=test::lsp::lsp_interaction::configuration::test_workspace_pythonpath_ignored_when_set_in_config_file"
    "--skip=test::lsp::lsp_interaction::notebook_sync::test_notebook_publish_diagnostics"
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
