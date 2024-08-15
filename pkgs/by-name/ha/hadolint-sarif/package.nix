{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "hadolint-sarif";
  version = "0.6.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wMb/taAAR0W8YVowNik0S8nFSmsD6LAQ5Egn0k52U74=";
  };

  cargoHash = "sha256-OpUUmte/NfMNbyO3H4ikJF5ALnvfNkUBwFhIN9vefd0=";

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
