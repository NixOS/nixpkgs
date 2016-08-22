{stdenv, fetchurl, pkgconfig, gtk, libpng}:

assert pkgconfig != null && gtk != null && libpng != null;
# Note that we cannot just copy gtk's png attribute, since gtk might
# not be linked against png.
# !!! assert libpng == gtk.libpng;

stdenv.mkDerivation {
  name = "gqview-2.1.5";

  src = fetchurl {
    url = mirror://sourceforge/gqview/gqview-2.1.5.tar.gz;
    md5 = "4644187d9b14b1dc11ac3bb146f262ea";
  };

  buildInputs = [pkgconfig gtk libpng];

  hardeningDisable = [ "format" ];

  meta = {
    description = "A fast image viewer";
    homepage = http://gqview.sourceforge.net;
    platforms = stdenv.lib.platforms.unix;
  };
}
