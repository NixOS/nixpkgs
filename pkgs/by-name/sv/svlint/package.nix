{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.9.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-YtBI2AnwSyeirHAXRavRKayfAmgXyyCMNhfEbUMXPgk=";
  };

  cargoHash = "sha256-78v28MEW06AIMZa2lNmql3/3t6bI+HCW48vKzRTDjFQ=";

  cargoBuildFlags = [
    "--bin"
    "svlint"
  ];

  meta = {
    description = "SystemVerilog linter";
    mainProgram = "svlint";
    homepage = "https://github.com/dalance/svlint";
    changelog = "https://github.com/dalance/svlint/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ trepetti ];
  };
}
