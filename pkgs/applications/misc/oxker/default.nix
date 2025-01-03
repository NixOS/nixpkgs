{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bn+5LBqZNwrhVX0KfXNBS00rE+BybN/NJmL4lu/oua0=";
  };

  cargoHash = "sha256-ssjLfNPP8g+2IOv0AQb+Soe/0e1H2LoqFSpmljj/z3o=";

  meta = with lib; {
    description = "Simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
    mainProgram = "oxker";
  };
}
