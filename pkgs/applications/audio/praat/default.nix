{stdenv, fetchurl, alsaLib, gtk, pkgconfig }:

stdenv.mkDerivation {
  name = "praat-5323";
  src = fetchurl {
    url = http://www.fon.hum.uva.nl/praat/praat5323_sources.tar.gz;
    sha256 = "1m0m5165h74mw5xhmnnyzh5ans3cn78w5rs9572sa1512cams203";
  };

  configurePhase = ''
    cp makefiles/makefile.defs.linux makefile.defs
  '';

  installPhase = ''
    ensureDir $out/bin
    cp praat $out/bin
  '';

  buildInputs = [ alsaLib gtk pkgconfig ];

  meta = {
    description = "Doing phonetics by computer";
    homepage = http://www.fon.hum.uva.nl/praat/;
    license = "GPLv2+"; # Has some 3rd-party code in it though
  };
}
