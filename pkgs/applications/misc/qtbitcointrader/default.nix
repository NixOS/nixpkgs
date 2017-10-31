{ stdenv, fetchurl, qt5 }:

let
  version = "1.10.01";
in
stdenv.mkDerivation {
  name = "qtbitcointrader-${version}";

  src = fetchurl {
    url = "https://github.com/JulyIGHOR/QtBitcoinTrader/archive/v${version}.tar.gz";
    sha256 = "0pgj8rsk9yxvls7yjpzblzbci2vvd0mlf9c7wdbjhwf6qyi7dfi3";
  };

  buildInputs = [ qt5.qtbase qt5.qtmultimedia qt5.qtscript ];

  postUnpack = "sourceRoot=\${sourceRoot}/src";

  configurePhase = ''
    runHook preConfigure
    qmake $qmakeFlags \
      PREFIX=$out \
      DESKTOPDIR=$out/share/applications \
      ICONDIR=$out/share/pixmaps \
      QtBitcoinTrader_Desktop.pro
    runHook postConfigure
  '';

  meta = with stdenv.lib;
    { description = "Bitcoin trading client";
      homepage = https://centrabit.com/;
      license = licenses.lgpl3;
      platforms = qt5.qtbase.meta.platforms;
      maintainers = [ maintainers.ehmry ];
    };
}
