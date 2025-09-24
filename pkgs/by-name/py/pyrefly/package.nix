{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-HPPDsvWEFfh/GNMUPiVjQr28YBBs2DACBGM3cxo5Nx4=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-46kcoBG/PWwf8VdlvLNzEhfYRTmmKi/uTjwFkl7Wozg=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
