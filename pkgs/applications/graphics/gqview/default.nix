{stdenv, fetchurl, pkgconfig, gtk, libpng}:

assert pkgconfig != null && gtk != null && libpng != null;
# Note that we cannot just copy gtk's png attribute, since gtk might
# not be linked against png.
# !!! assert libpng == gtk.libpng;

stdenv.mkDerivation {
  name = "gqview-1.4.5";

  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/gqview-1.4.5.tar.gz;
    md5 = "b196935767c2d3dc61243d9ed0801c2e";
  };

  buildInputs = [pkgconfig gtk libpng];
}
