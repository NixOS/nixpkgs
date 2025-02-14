{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "feluda";
  version = "2.7.7";

  src = fetchFromGitHub {
    owner = "anistark";
    repo = pname;
    rev = "98fd4a640cec620dee85c595ec1376949bb025e5";
    sha256 = "q1IzSTnIczG+yJgPtzd9xoylNO1PvdxZk97KVmZ4Fqw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = with lib; {
    description = "Detect license usage restrictions in your project! ";
    homepage = "https://github.com/anistark/feluda";
    license = licenses.mit;
    maintainers = with maintainers; [ transgirl_lucy ];
    mainProgram = "feluda";
  };
}
