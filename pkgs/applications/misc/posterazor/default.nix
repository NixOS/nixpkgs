{ lib, stdenv, fetchurl, cmake, unzip, pkg-config, libXpm, fltk13, freeimage }:

stdenv.mkDerivation rec {
  pname = "posterazor";
  version = "1.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/posterazor/${version}/PosteRazor-${version}-Source.zip";
    sha256 = "1dqpdk8zl0smdg4fganp3hxb943q40619qmxjlga9jhjc01s7fq5";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ cmake pkg-config unzip ];
  buildInputs = [ libXpm fltk13 freeimage ];

  unpackPhase = ''
    unzip $src -d posterazor
    cd posterazor/src
  '';

  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=667328
  patchPhase = ''
    sed "s/\(#define CASESENSITIVESTRCMP strcasecmp\)/#include <unistd.h>\n\1/" -i FlPosteRazorDialog.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp PosteRazor $out/bin
  '';

  meta = with lib; {
    homepage = "http://posterazor.sourceforge.net/";
    description = "Cuts a raster image into pieces which can afterwards be printed out and assembled to a poster";
    maintainers = [ maintainers.madjar ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
