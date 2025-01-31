{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "planarity";
  version = "3.0.2.0";

  src = fetchFromGitHub {
    owner = "graph-algorithms";
    repo = "edge-addition-planarity-suite";
    rev = "Version_${version}";
    sha256 = "sha256-cUAh2MXCSmtxFtV6iTHgSRgsq/26DjWwxhWJH1+367A=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/graph-algorithms/edge-addition-planarity-suite";
    description = "Library for implementing graph algorithms";
    mainProgram = "planarity";
    license = licenses.bsd3;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
