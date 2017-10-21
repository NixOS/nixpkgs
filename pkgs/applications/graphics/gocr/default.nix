{ stdenv, fetchurl, tk }:

stdenv.mkDerivation rec {
  name = "gocr-0.50";

  src = fetchurl {
    url = "http://www-e.uni-magdeburg.de/jschulen/ocr/${name}.tar.gz";
    sha256 = "1dgmcpapy7h68d53q2c5d0bpgzgfb2nw2blndnx9qhc7z12149mw";
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
