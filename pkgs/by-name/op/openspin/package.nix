{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "openspin";
  version = "unstable-2018-10-02";

  src = fetchFromGitHub {
    owner = "parallaxinc";
    repo = "OpenSpin";
    rev = "f3a587ed3e4f6a50b3c8d2022bbec5676afecedb";
    hash = "sha256-1iSZgwb6cLhDA4CFpQWkxwTQ4Kz+vXouZ8Asq9pf084=";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv build/openspin $out/bin/openspin
  '';

  meta = {
    description = "Compiler for SPIN/PASM languages for Parallax Propeller MCU";
    mainProgram = "openspin";
    homepage = "https://github.com/parallaxinc/OpenSpin";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.redvers ];
    platforms = lib.platforms.all;
  };
}
