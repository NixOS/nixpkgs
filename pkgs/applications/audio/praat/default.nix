{ stdenv, fetchurl, alsaLib, gtk2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "praat-${version}";
  version = "6.0.42";

  src = fetchurl {
    url = "https://github.com/praat/praat/archive/v${version}.tar.gz";
    sha256 = "1llcj1cq4k60lnr6jkdshd4l9nkg9yc2xmaqiinqryxrb58jmpcv";
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
