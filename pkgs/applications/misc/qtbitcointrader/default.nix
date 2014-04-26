{ stdenv, fetchurl, qt4 }:

let
  version = "1.07.98";
in
stdenv.mkDerivation {
  name = "qtbitcointrader-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/bitcointrader/SRC/QtBitcoinTrader-${version}.tar.gz";
    sha256 = "1irz17q71fx64dfkmgajlyva7d1wifv4bxgb2iwz7d69rvhzaqzx";
  };

  buildInputs = [ qt4 ];

  postUnpack = "sourceRoot=\${sourceRoot}/src";

  configurePhase = ''
    qmake \
      PREFIX=$out \
      DESKTOPDIR=$out/share/applications \
      ICONDIR=$out/share/pixmaps \
        QtBitcoinTrader_Desktop.pro
  '';

  meta = {
    description = "Secure bitcoin trading client";
    homepage = http://qtopentrader.com;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;  # arbitrary choice
    maintainers = [ stdenv.lib.maintainers.emery ];
  };
}