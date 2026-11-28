{
  lib,
  stdenv,
  bash,
  replaceVars,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  pkg-config,
  rust-jemalloc-sys,
  zstd,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "meta";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-hzHMT9xZnBT8tYt7JeJd4dglCKmOc/2sfJmPHI2o4uU=";
  };

  buildAndTestSubdir = "pyrefly";

  cargoHash = "sha256-PQ4O4gBDXouiKaBgH7RFrWSdM9gcBFBGJxcSA+n/BwI=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    rust-jemalloc-sys
    zstd
  ];

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

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pyrefly \
      --bash <($out/bin/pyrefly completion --shell bash) \
      --fish <($out/bin/pyrefly completion --shell fish) \
      --zsh <($out/bin/pyrefly completion --shell zsh) \
      --powershell <($out/bin/pyrefly completion --shell powershell)
  '';

  # avoid autoupdates for *-dev.* tags
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^([\\d.]+)$" ];
  };

  meta = {
    description = "Fast type checker and IDE for Python";
    homepage = "https://github.com/meta/pyrefly";
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
