{ stdenv, fetchurl, alsaLib, gtk, pkgconfig }:

let version = "5401"; in
stdenv.mkDerivation {
  name = "praat-${version}";

  src = fetchurl {
    url = "http://www.fon.hum.uva.nl/praat/praat${version}_sources.tar.gz";
    sha256 = "1hx0simc0hp5w5scyaiw8h8lrpafra4h1zy1jn1kzb0299yd06n3";
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
