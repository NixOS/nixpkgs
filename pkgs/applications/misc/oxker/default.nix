{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.1.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-kMomzIViN7ooBsjUfCIk0XRi4WtXtiaHWHT2pECx//k=";
  };

  cargoSha256 = "sha256-ASBu4p8+/Donmynnyryktc6dXA3yiOb9w5XpmN4PotY=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
