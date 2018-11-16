{ stdenv, fetchurl, pkgconfig, libtool, gtk3, libpcap, goocanvas2,
popt, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "etherape-0.9.18";
  src = fetchurl {
    url = "mirror://sourceforge/etherape/${name}.tar.gz";
    sha256 = "0y9cfc5iv5zy82j165i9agf45n1ixka064ykdvpdhb07sr3lzhmv";
  };

  nativeBuildInputs = [ itstool pkgconfig (stdenv.lib.getBin libxml2) ];
  buildInputs = [
    libtool gtk3 libpcap goocanvas2 popt
  ];

  meta = with stdenv.lib; {
    homepage = http://etherape.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ symphorien ];
  };
}
