{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mi2ly";
  version = "0.12";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/mi2ly/mi2ly.${version}.tar.bz2";
    sha256 = "sha256-lFbqH+syFaQDMbXfb+OUcWnyKnjfVz9yl7DbTTn7JKw=";
  };

  sourceRoot = ".";

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = toString [ "-fgnu89-inline" ];

  buildPhase = "./cc";
  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/mi2ly}
    cp mi2ly "$out/bin"
    cp README Doc.txt COPYING Manual.txt "$out/share/doc/mi2ly"
  '';

  meta = with lib; {
    description = "MIDI to Lilypond converter";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "https://www.nongnu.org/mi2ly/";
    mainProgram = "mi2ly";
  };
}
