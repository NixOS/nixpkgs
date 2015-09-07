{ stdenv, fetchurl, alsaLib, gtk, pkgconfig }:

let version = "5417"; in
stdenv.mkDerivation {
  name = "praat-${version}";

  src = fetchurl {
    url = "http://www.fon.hum.uva.nl/praat/praat${version}_sources.tar.gz";
    sha256 = "1bspl963pb1s6k3cd9p3g5j518pxg6hkrann945lqsrvbzaa20kl";
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
