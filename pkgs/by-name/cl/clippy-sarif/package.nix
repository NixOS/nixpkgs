{
  lib,
  fetchCrate,
  rustPlatform,
  clippy,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clippy-sarif";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ylfL4N1BtbB1R7+Glwtgn5E6/v3wQ6oXWdmeyKNHdOw=";
  };

  cargoHash = "sha256-O0bLgj7rWwbEswVMfexsBGgJyObxseOohYht21Y6HpU=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A CLI tool to convert clippy diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "clippy-sarif";
    inherit (clippy.meta) platforms;
  };
}
