{ lib, stdenv, fetchurl, pkg-config, libtool, gtk3, libpcap, goocanvas2,
popt, itstool, libxml2 }:

stdenv.mkDerivation rec {
  pname = "etherape";
  version = "0.9.20";
  src = fetchurl {
    url = "mirror://sourceforge/etherape/etherape-${version}.tar.gz";
    sha256 = "sha256-9UsQtWOXB1yYofGS4rMIF+ISWBsJKd0DBOFfqOr1n5Y=";
  };

  nativeBuildInputs = [ itstool pkg-config (lib.getBin libxml2) ];
  buildInputs = [
    libtool gtk3 libpcap goocanvas2 popt
  ];

  meta = with lib; {
    homepage = "http://etherape.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ symphorien ];
  };
}
