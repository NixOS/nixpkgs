{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-XY3LwDagxSi1yeAfqhnbtNRBqJxp0BkhaYZM/T59tGw=";
  };

  cargoHash = "sha256-SeNrVw1m0B9CV31Pa41YinviWbEdiw50sdcrQpndiCI=";

  meta = with lib; {
    description = "Simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
    mainProgram = "oxker";
  };
}
