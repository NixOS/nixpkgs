{ stdenv, fetchurl, cmake, unzip, pkgconfig, libXpm, fltk13, freeimage }:

stdenv.mkDerivation rec {
  name = "posterazor-1.5";

  src = fetchurl {
    url = "mirror://sourceforge/posterazor/1.5/PosteRazor-1.5-Source.zip";
    sha256 = "0xy313d2j57s4wy2y3hjapbjr5zfaki0lhkfz6nw2p9gylcmwmjy";
  };

  buildInputs = [ cmake unzip pkgconfig libXpm fltk13 freeimage ];

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

  meta = {
    homepage = "http://posterazor.sourceforge.net/";
    description = "The PosteRazor cuts a raster image into pieces which can afterwards be printed out and assembled to a poster";
    maintainers = [ stdenv.lib.maintainers.madjar ];
    platforms = stdenv.lib.platforms.all;
  };
}
