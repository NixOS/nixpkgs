{stdenv, fetchurl, unzip, portaudio }:

stdenv.mkDerivation {
  name = "espeak-1.44.03";
  src = fetchurl {
    url = mirror://sourceforge/espeak/espeak-1.44.03-source.zip;
    sha256 = "0lnv89xmsq3bax0qpabd0z2adaag7mdl973bkw3gdszidafmfyx4";
  };

  buildInputs = [ unzip portaudio ];

  patchPhase = ''
    sed -e s,/bin/ln,ln,g -i src/Makefile
    sed -e 's,^CXXFLAGS=-O2,CXXFLAGS=-O2 -D PATH_ESPEAK_DATA=\\\"$(DATADIR)\\\",' -i src/Makefile
  '' + (if portaudio.api_version == 19 then ''
    cp src/portaudio19.h src/portaudio.h
  '' else "");

  configurePhase = ''
    cd src
    makeFlags="PREFIX=$out"
  '';

  meta = {
    description = "Compact open source software speech synthesizer";
    homepage = http://espeak.sourceforge.net/;
    license = "GPLv3+";
  };
}
