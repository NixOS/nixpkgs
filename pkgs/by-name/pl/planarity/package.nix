{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "planarity";
  version = "5.0.0.0";

  src = fetchFromGitHub {
    owner = "graph-algorithms";
    repo = "edge-addition-planarity-suite";
    rev = "Version_${finalAttrs.version}";
    sha256 = "sha256-sDEP5uICZRGPFDfrfN7hfxQ7R9hc1fYkzocc8BOUeFQ=";
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
})
