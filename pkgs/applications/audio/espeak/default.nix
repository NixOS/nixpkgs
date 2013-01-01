{stdenv, fetchurl, unzip, portaudio }:

stdenv.mkDerivation {
  name = "espeak-1.46.02";
  src = fetchurl {
    url = mirror://sourceforge/espeak/espeak-1.46.02-source.zip;
    sha256 = "1fjlv5fm0gzvr5wzy1dp4nspw04k0bqv3jymha2p2qfjbfifp2zg";
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
    makeFlags="PREFIX=$out DATADIR=$out/share/espeak-data"
  '';

  meta = {
    description = "Compact open source software speech synthesizer";
    homepage = http://espeak.sourceforge.net/;
    license = "GPLv3+";
  };
}
