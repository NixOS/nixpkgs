{stdenv, fetchurl, pkgconfig, gtk, libpng}:

assert pkgconfig != null && gtk != null && libpng != null;
# Note that we cannot just copy gtk's png attribute, since gtk might
# not be linked against png.
assert libpng == gtk.libpng;

stdenv.mkDerivation {
  name = "gqview-1.3.5";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/gqview/gqview-1.3.5.tar.gz;
    md5 = "c44687bdd636ea6e5133fb936abf880a";
  };

  pkgconfig = pkgconfig;
  gtk = gtk;
  libpng = libpng;
}
