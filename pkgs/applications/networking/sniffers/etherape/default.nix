{ stdenv, fetchurl, pkgconfig, libtool, gtk2, libpcap, libglade,
libgnomecanvas, popt, itstool }:

stdenv.mkDerivation rec {
  name = "etherape-0.9.17";
  src = fetchurl {
    url = "mirror://sourceforge/etherape/${name}.tar.gz";
    sha256 = "1n66dw9nsl7zz0qfkb74ncgch3lzms2ssw8dq2bzbk3q1ilad3p6";
  };

  nativeBuildInputs = [ itstool pkgconfig ];
  buildInputs = [
    libtool gtk2 libpcap libglade libgnomecanvas popt
  ];

  meta = with stdenv.lib; {
    homepage = http://etherape.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ symphorien ];
  };
}
