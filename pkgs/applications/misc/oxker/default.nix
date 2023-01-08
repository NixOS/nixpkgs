{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "oxker";
  version = "0.1.11";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-O4fVEYstDkVHn7fBVOGu1ok9K9xiO9uLx0+vb6qMZoA=";
  };

  cargoHash = "sha256-LSMAE24E8Is/ejUE/2vogP0GmpF+9oO2pJoQOZ8OfU8=";

  meta = with lib; {
    description = "A simple tui to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siph ];
  };
}
