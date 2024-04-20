{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.6.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-pHyIL5Jmldsa0ZNMiYpBD+9zxPv8Blg23nnWD2YmHMI=";
  };

  cargoHash = "sha256-N1Cv89njL9QCIs3HclcjsqgSUSMEckis8zyVqepeW70=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
    mainProgram = "oxker";
  };
}
