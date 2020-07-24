{ stdenv, fetchurl, pkgconfig, libtool, gtk3, libpcap, goocanvas2,
popt, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "etherape-0.9.19";
  src = fetchurl {
    url = "mirror://sourceforge/etherape/${name}.tar.gz";
    sha256 = "0w63vg2q6if3wvy2md66in8b6cdw9q40hny5xy6yrxky58l4kmg7";
  };

  nativeBuildInputs = [ itstool pkgconfig (stdenv.lib.getBin libxml2) ];
  buildInputs = [
    libtool gtk3 libpcap goocanvas2 popt
  ];

  meta = with stdenv.lib; {
    homepage = "http://etherape.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ symphorien ];
  };
}
