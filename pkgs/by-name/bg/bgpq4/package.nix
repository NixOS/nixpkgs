{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "bgpq4";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = "bgpq4";
    rev = version;
    sha256 = "sha256-3mfFj9KoQbDe0gH7Le03N1Yds/bTEmY+OiXNaOtHkpY=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    description = "BGP filtering automation tool";
    homepage = "https://github.com/bgp/bgpq4";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ vincentbernat ];
    platforms = with lib.platforms; unix;
    mainProgram = "bgpq4";
  };
}
