{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "cacti";
  version = "7.0";

  src = fetchFromGitHub {
    owner = "HewlettPackard";
    repo = "cacti";
    rev = "1ffd8dfb10303d306ecd8d215320aea07651e878";
    sha256 = "sha256-lrbrwKlaVvwEUDZA/n8I/zYNX3T8ltiBTYL94Ce5UQU=";
  };

  buildPhase = ''
    make -f makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp cacti $out/bin/
  '';

  meta = {
    description = "Integrated cache and memory access time, cycle time, area, leakage, and dynamic power model";
    homepage = "http://www.hpl.hp.com/research/cacti/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hakan-demirli ];
    platforms = lib.platforms.linux;
    mainProgram = "cacti";
  };
}
