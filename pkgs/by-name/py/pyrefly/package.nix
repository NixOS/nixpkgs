{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-sI+F+kI8ApE1cHpE3q/tSntaD/1c26jT5BLJ3BtzpBA=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-+93SQA0KrJsskXUMA9S5eaq0EIWVK1/ZoUbp6wQ7Cc4=";

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
