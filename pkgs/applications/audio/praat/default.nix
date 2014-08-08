{ stdenv, fetchurl, alsaLib, gtk, pkgconfig }:

stdenv.mkDerivation {
  name = "praat-5365";

  src = fetchurl {
    url = http://www.fon.hum.uva.nl/praat/praat5365_sources.tar.gz;
    sha256 = "1w3mcq0mipx88i7ckhvzhmdj0p67nhppnn7kbkp21d01yyyz5rgq";
  };

  configurePhase = ''
    cp makefiles/makefile.defs.linux.alsa makefile.defs
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp praat $out/bin
  '';

  buildInputs = [ alsaLib gtk pkgconfig ];

  meta = {
    description = "Doing phonetics by computer";
    homepage = http://www.fon.hum.uva.nl/praat/;
    license = stdenv.lib.licenses.gpl2Plus; # Has some 3rd-party code in it though
    platforms = stdenv.lib.platforms.linux;
  };
}
