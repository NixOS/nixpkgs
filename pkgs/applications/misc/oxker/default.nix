{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-DylYRuEy0qjhjCEoTmjCJAT3nD31D8Xaaw13oexViAg=";
  };

  cargoHash = "sha256-gmzXl2psj4mftX/0Hsbki/eRQHWnspkYlzQAX4gv4vo=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
