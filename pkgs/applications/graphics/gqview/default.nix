{stdenv, fetchurl, pkgconfig, gtk, libpng}:

assert pkgconfig != null && gtk != null && libpng != null;
# Note that we cannot just copy gtk's png attribute, since gtk might
# not be linked against png.
# !!! assert libpng == gtk.libpng;

stdenv.mkDerivation {
  name = "gqview-1.4.1";

  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/gqview/gqview-1.4.1.tar.gz;
    md5 = "d963fbb878d78e8ebf78ea8c18caa72f";
  };

  buildInputs = [pkgconfig gtk libpng];
}
