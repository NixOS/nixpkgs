{stdenv, fetchurl, pkgconfig, gtk, libpng}:

assert pkgconfig != null && gtk != null && libpng != null;
# Note that we cannot just copy gtk's png attribute, since gtk might
# not be linked against png.
# !!! assert libpng == gtk.libpng;

stdenv.mkDerivation {
  name = "gqview-1.4.4";

  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/gqview/gqview-1.4.4.tar.gz;
    md5 = "b3f1e1ca830c9cc0b484966fac9e6f28";
  };

  buildInputs = [pkgconfig gtk libpng];
}
