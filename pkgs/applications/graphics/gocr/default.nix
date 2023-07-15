{ lib, stdenv, fetchurl, tk }:

stdenv.mkDerivation rec {
  pname = "gocr";
  version = "0.52";

  src = fetchurl {
    url = "https://www-e.uni-magdeburg.de/jschulen/ocr/gocr-${version}.tar.gz";
    sha256 = "11l6gds1lrm8lwrrsxnm5fjlwz8q1xbh896cprrl4psz21in946z";
  };

  buildFlags = [ "all" "libs" ];
  installFlags = [ "libdir=/lib/" ]; # Specify libdir so Makefile will also install library.

  preInstall = "mkdir -p $out/lib";

  postInstall = ''
    for i in pgm2asc.h gocr.h; do
      install -D -m644 src/$i $out/include/gocr/$i
    done
  '';

  preFixup = ''
    sed -i -e 's|exec wish|exec ${tk}/bin/wish|' $out/bin/gocr.tcl
  '';

  meta = {
    homepage = "https://jocr.sourceforge.net/";
    description = "GPL Optical Character Recognition";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
