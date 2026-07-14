{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-lsp";
  version = "0.4.8";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "terror";
    repo = "just-lsp";
    tag = finalAttrs.version;
    hash = "sha256-fSr3Nv7KsVMntGpL/uThdY4atCFqbSAS3XsNbdwoCvs=";
  };

  cargoHash = "sha256-z0Gyh44/9nAz505k4B7sZN8BO3kyUutnfivj3QaTi3c=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for just";
    homepage = "https://github.com/terror/just-lsp";
    changelog = "https://github.com/terror/just-lsp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "just-lsp";
  };
})
