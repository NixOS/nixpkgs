{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.1.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-OhXU61F8XK5ts4GwDUkFv4+FGNFUmJJ9ooRS9/D0yvQ=";
  };

  cargoSha256 = "sha256-ldf0XYBhxLL2v0+yBX9Dqq8kYgJZ2f4Lor+rUA0/47E=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
