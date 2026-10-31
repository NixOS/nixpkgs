{
  lib,
  bash,
  replaceVars,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  rust-jemalloc-sys,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-I+EdNCtwfrCXHZ/wRaxtBW75dw2zQu0PB3b0u5GkyxQ=";
  };

  buildAndTestSubdir = "pyrefly";

  cargoHash = "sha256-1DKqc6V5QWqViZpq4CLnlLe/b58femYuq57rlJ2c5+w=";

  buildInputs = [ rust-jemalloc-sys ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  patches = [
    (replaceVars ./fix-shebang.patch { bash = lib.getExe bash; })
  ];

  # redirect tests writing to /tmp
  preCheck = ''
    export TMPDIR=$(mktemp -d)
  '';

  # This test can deadlock
  checkFlags = [
    "--skip=test::lsp::lsp_interaction::file_watcher::test_incremental_pattern_addition"
  ];

  # avoid autoupdates for *-dev.* tags
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^([\\d.]+)$" ];
  };

  meta = {
    description = "Fast type checker and IDE for Python";
    homepage = "https://github.com/facebook/pyrefly";
    license = lib.licenses.mit;
    mainProgram = "pyrefly";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      cybardev
      QuiNzX
      evanwporter
    ];
  };
})
