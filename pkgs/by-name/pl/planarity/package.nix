{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "planarity";
  version = "4.0.0.0";

  src = fetchFromGitHub {
    owner = "graph-algorithms";
    repo = "edge-addition-planarity-suite";
    rev = "Version_${version}";
    sha256 = "sha256-A7huHvMgUyvw2zM9qA7Ax/1Ai5VZ6A1PZIo3eiCpu44=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/graph-algorithms/edge-addition-planarity-suite";
    description = "Library for implementing graph algorithms";
    mainProgram = "planarity";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
  };
}
