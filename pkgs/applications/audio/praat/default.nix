{ stdenv, fetchurl, alsaLib, gtk2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "praat-${version}";
  version = "6.0.37";

  src = fetchurl {
    url = "https://github.com/praat/praat/archive/v${version}.tar.gz";
    sha256 = "1c675jfzcrwfn8lcswm5y5kmazkhnb0p4mzlf5sim57hms88ffjq";
  };

  configurePhase = ''
    cp makefiles/makefile.defs.linux.alsa makefile.defs
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp praat $out/bin
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib gtk2 ];

  meta = {
    description = "Doing phonetics by computer";
    homepage = http://www.fon.hum.uva.nl/praat/;
    license = stdenv.lib.licenses.gpl2Plus; # Has some 3rd-party code in it though
    platforms = stdenv.lib.platforms.linux;
  };
}
