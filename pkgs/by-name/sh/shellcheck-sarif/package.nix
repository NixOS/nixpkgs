{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "shellcheck-sarif";
  version = "0.6.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-NPf8BkrpqM/MaVha9/AIuUXPQpslslLFv0l9a0lzYyc=";
  };

  cargoHash = "sha256-YUyZZcSaBqnc216Hu+BAv1raNFRzSnikedr+/n8wTbE=";

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
