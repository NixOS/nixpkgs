{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.3.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-2zdsVItGZYQydpC9E/uCbzOE9Xoh7zTqa9DpxA5qNCc=";
  };

  cargoHash = "sha256-FXYFQpiK2BGUz9GjsUPS9LWPeezbBQ3A33juoVCl71g=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
