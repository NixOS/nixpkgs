{stdenv, fetchurl, pkgconfig, gtk2, libpng}:

assert pkgconfig != null && gtk2 != null && libpng != null;
# Note that we cannot just copy gtk's png attribute, since gtk might
# not be linked against png.
# !!! assert libpng == gtk2.libpng;

stdenv.mkDerivation {
  name = "gqview-2.1.5";

  src = fetchurl {
    url = mirror://sourceforge/gqview/gqview-2.1.5.tar.gz;
    sha256 = "0ilm5s7ps9kg4f5hzgjhg0xhn6zg0v9i7jnd67zrx9h7wsaa9zhj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 libpng];

  hardeningDisable = [ "format" ];

  NIX_LDFLAGS = "-lm";

  meta = with stdenv.lib; {
    description = "A fast image viewer";
    homepage = http://gqview.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
