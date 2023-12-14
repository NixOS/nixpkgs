{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-zre4ccMmv1NWcokLvEFRIf+kornAnge/a3c3b6IO03o=";
  };

  cargoHash = "sha256-xdfaTVRt5h4q0kfAE1l6pOXCfk0Cb8TnKNMZeeGvciY=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
