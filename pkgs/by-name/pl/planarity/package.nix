{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "planarity";
  version = "4.0.1.0";

  src = fetchFromGitHub {
    owner = "graph-algorithms";
    repo = "edge-addition-planarity-suite";
    rev = "Version_${version}";
    sha256 = "sha256-uSCQSn3LRi3eQynh71fs1xhVIrPcOqVyGzdHAK9xj7E=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/graph-algorithms/edge-addition-planarity-suite";
    description = "Library for implementing graph algorithms";
    mainProgram = "planarity";
    license = licenses.bsd3;
    teams = [ teams.sage ];
    platforms = platforms.unix;
  };
}
