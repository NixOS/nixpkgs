{ stdenv, fetchurl, tk }:

stdenv.mkDerivation rec {
  name = "gocr-0.51";

  src = fetchurl {
    url = "https://www-e.uni-magdeburg.de/jschulen/ocr/${name}.tar.gz";
    sha256 = "14i6zi6q11h6d0qds2cpvgvhbxk5xaa027h8cd0wy1zblh7sxckf";
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
    homepage = http://jocr.sourceforge.net/;
    description = "GPL Optical Character Recognition";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
