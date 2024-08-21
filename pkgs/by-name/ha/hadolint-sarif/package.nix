{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "hadolint-sarif";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7i3fhXZJ82+a4kbMPMxW8dV42qxQfQggwkm8FA1TUkw=";
  };

  cargoHash = "sha256-DXCdxpvWaOn/g7kuqgmtGkd94NVnjPI9VkDCuPg7wCw=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A CLI tool to convert hadolint diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "hadolint-sarif";
  };
}
