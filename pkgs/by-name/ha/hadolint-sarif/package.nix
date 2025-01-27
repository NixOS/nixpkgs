{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "hadolint-sarif";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-HPGVqAk1bXzeblTc4AnCLsHB60CKFV8ImO+MFqM10YI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1nl5Myr8o1gyvkpsdMVLjZqnLkULOmxUOT0NmVe+0Oo=";

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
