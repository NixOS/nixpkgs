{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  zlib,
  boost,
}:

let
  glucose' = fetchurl {
    url = "http://www.labri.fr/perso/lsimon/downloads/softwares/glucose-syrup.tgz";
    sha256 = "0bq5l2jabhdfhng002qfk0mcj4pfi1v5853x3c7igwfrgx0jmfld";
  };
in

stdenv.mkDerivation {
  pname = "aspino";
  version = "unstable-2018-03-24";

  src = fetchFromGitHub {
    owner = "alviano";
    repo = "aspino";
    rev = "4d7483e328bdf9a00ef1eb7f2868e7b0f2a82d56";
    hash = "sha256-R1TpBDGdq+NQQzmzqk0wYaz2Hns3qru0AkAyFPQasPA=";
  };

  buildInputs = [
    zlib
    boost
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "GCC = g++" "GCC = c++"
    substituteInPlace src/main.cc \
      --replace "defined(__linux__)" "defined(__linux__) && defined(__x86_64__)"
    substituteInPlace src/MaxSatSolver.cc \
      --replace "occ[i][sign(softLiterals[j])] > 0" "occ[i][sign(softLiterals[j])] != 0"
  '';

  preBuild = ''
    cp ${glucose'} patches/glucose-syrup.tgz
    ./bootstrap.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m0755 build/release/{aspino,fairino-{bs,ls,ps},maxino-2015-{k16,kdyn}} $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "SAT/PseudoBoolean/MaxSat/ASP solver using glucose";
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
    license = licenses.asl20;
    homepage = "https://alviano.net/software/maxino/";
  };
}
