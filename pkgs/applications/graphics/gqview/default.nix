{stdenv, fetchurl, pkgconfig, gtk, libpng}:

assert pkgconfig != null && gtk != null && libpng != null;
# Note that we cannot just copy gtk's png attribute, since gtk might
# not be linked against png.
# !!! assert libpng == gtk.libpng;

stdenv.mkDerivation {
  name = "gqview-2.0.0";

  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/gqview/gqview-2.0.0.tar.gz;
    md5 = "421c9a79827e91e394bdfc924071d66f";
  };

  buildInputs = [pkgconfig gtk libpng];
}
