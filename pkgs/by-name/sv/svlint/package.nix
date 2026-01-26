{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.9.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-RjdhXp9Dm6ZrRfJKsjnzAFgXTIQB3DJmDMwwtQD4Uzw=";
  };

  cargoHash = "sha256-in8DObo5QENl1N36lI16DpEXepFU3Y0BYkJOXinmUjE=";

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
