{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "openspin";
  version = "unstable-2018-10-02";

  src = fetchFromGitHub {
    owner = "parallaxinc";
    repo = "OpenSpin";
    rev = "f3a587ed3e4f6a50b3c8d2022bbec5676afecedb";
    sha256 = "1knkbzdanb60cwp7mggymkhd0167lh2sb1c00d1vhw7s0s1rj96n";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv build/openspin $out/bin/openspin
  '';

  meta = with lib; {
    description = "Compiler for SPIN/PASM languages for Parallax Propeller MCU";
    mainProgram = "openspin";
    homepage = "https://github.com/parallaxinc/OpenSpin";
    license = licenses.mit;
    maintainers = [ maintainers.redvers ];
    platforms = platforms.all;
  };
}
