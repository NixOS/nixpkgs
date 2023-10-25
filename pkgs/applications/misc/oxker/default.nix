{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-35MHq2G2L7yfz+W9uUaRb8fpEp/h0bt2HtK615XwZG8=";
  };

  cargoHash = "sha256-goIb8BoHSF0g/OWmeZtha+qKlcvLTqwMmYcD2uYUI7E=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
