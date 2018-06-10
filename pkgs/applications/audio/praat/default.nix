{ stdenv, fetchurl, alsaLib, gtk2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "praat-${version}";
  version = "6.0.40";

  src = fetchurl {
    url = "https://github.com/praat/praat/archive/v${version}.tar.gz";
    sha256 = "168qrrr59qxii265vba7pj6f61lzq5lk9c43zcda0wmmjp87bq1x";
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
