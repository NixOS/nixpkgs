{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-lsp";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "terror";
    repo = "just-lsp";
    tag = finalAttrs.version;
    hash = "sha256-ew8/ugjSkCus5Fd/SpXfWKspvdOR6FC/Q2gBzWO3OOw=";
  };

  cargoHash = "sha256-YejdnLECFCmuYfmj6rYnKKsMD5HkHsYnS8gs4f3iCcw=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Language server for just";
    homepage = "https://github.com/terror/just-lsp";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "just-lsp";
  };
})
