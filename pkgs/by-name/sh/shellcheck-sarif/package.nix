{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "shellcheck-sarif";
  version = "0.6.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-fvOxZd6xLyOm1OjK24Xx6uHz2e8eyIklX1kUAuRGcyY=";
  };

  cargoHash = "sha256-jHOCjZ6NAU8YmAc2T1aCSaa2Yx9wkP361LZ2MKAWVLA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI tool to convert shellcheck diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "shellcheck-sarif";
  };
}
