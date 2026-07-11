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
  version = "1.2.0-dev.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-qi2ImB2fuaDJWlJpPSlopZZmdGplEGm6+31yNOP+b8g=";
  };

  buildAndTestSubdir = "pyrefly";

  cargoHash = "sha256-Q/xB79oR0yvXCT1bCPU82LUDrGpTUMt+uy67Si+mWL8=";

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
