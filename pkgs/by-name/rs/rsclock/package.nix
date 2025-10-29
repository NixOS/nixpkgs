{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rsClock";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "valebes";
    repo = "rsClock";
    rev = "v${version}";
    sha256 = "sha256-l5750zP90KnB+OIg1WOikQ6OgQZK4iwVvGBN3jegjGc=";
  };

  cargoHash = "sha256-Bnec98FEG2aWUa2IoBOLy0K6mqggcSwOBL3S5+0mSkU=";

  meta = with lib; {
    description = "Simple terminal clock written in Rust";
    homepage = "https://github.com/valebes/rsClock";
    license = licenses.mit;
    maintainers = with maintainers; [ valebes ];
    mainProgram = "rsclock";
  };
}
