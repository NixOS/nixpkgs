{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "hadolint-sarif";
  version = "0.6.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-v1rbM1HEZpSIS07x4GyICu6OR7PfH89wNywlXXPh1to=";
  };

  cargoHash = "sha256-lojb6tESIl2kbVDUyoDf1CntvzJOtoZZJEyDs9PR7Gw=";

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
