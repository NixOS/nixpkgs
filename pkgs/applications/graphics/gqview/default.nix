{stdenv, fetchurl, pkgconfig, gtk, libpng}:

assert pkgconfig != null && gtk != null && libpng != null;
# Note that we cannot just copy gtk's png attribute, since gtk might
# not be linked against png.
# !!! assert libpng == gtk.libpng;

stdenv.mkDerivation {
  name = "gqview-1.4.3";

  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/gqview/gqview-1.4.3.tar.gz;
    md5 = "6a6a08309a91aab902304a3c6ed392eb";
  };

  buildInputs = [pkgconfig gtk libpng];
}
