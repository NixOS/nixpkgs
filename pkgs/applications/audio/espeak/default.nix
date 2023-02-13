{ lib, stdenv, fetchurl, unzip, portaudio }:

stdenv.mkDerivation rec {
  pname = "espeak";
  version = "1.48.04";

  src = fetchurl {
    url = "mirror://sourceforge/espeak/espeak-${version}-source.zip";
    sha256 = "0n86gwh9pw0jqqpdz7mxggllfr8k0r7pc67ayy7w5z6z79kig6mz";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ portaudio ];

  patches = [
    ./gcc6.patch
  ];

  prePatch = ''
    sed -e s,/bin/ln,ln,g -i src/Makefile
    sed -e 's,^CXXFLAGS=-O2,CXXFLAGS=-O2 -D PATH_ESPEAK_DATA=\\\"$(DATADIR)\\\",' -i src/Makefile
  '' + (if portaudio.api_version == 19 then ''
    cp src/portaudio19.h src/portaudio.h
  '' else "");

  configurePhase = ''
    cd src
    makeFlags="PREFIX=$out DATADIR=$out/share/espeak-data"
  '';

  meta = with lib; {
    description = "Compact open source software speech synthesizer";
    homepage = "https://espeak.sourceforge.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
