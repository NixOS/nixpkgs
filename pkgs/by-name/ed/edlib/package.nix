{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "edlib";
  version = "unstable-2021-08-20";

  src = fetchFromGitHub {
    owner = "Martinsos";
    repo = pname;
    rev = "f8afceb49ab0095c852e0b8b488ae2c88e566afd";
    hash = "sha256-P/tFbvPBtA0MYCNDabW+Ypo3ltwP4S+6lRDxwAZ1JFo=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    bin/runTests
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://martinsos.github.io/edlib";
    description = "Lightweight, fast C/C++ library for sequence alignment using edit distance";
    maintainers = with maintainers; [ bcdarwin ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
