{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.1.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-R7vtwUJVlqrt/71d1hbliJvkAhJx6A0Q5nsV71QO/tY=";
  };

  cargoSha256 = "sha256-LciBg74zyWdSv0FMHFpp/XtbBuzsfEalmiBNCL+i7Zg=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
