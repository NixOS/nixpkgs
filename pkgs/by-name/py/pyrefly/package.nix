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
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-F8r+kJx2nBwekeU2d2xLo+pggAzVWy0V0CV8Z0ZfLs8=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-vkqxRIbNEKJWNIIAMtny1XF6TSzV7KCpZPl+OCDEiPo=";

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
