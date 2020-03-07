{ stdenv, fetchzip, qt5, mkDerivation }:

let
  version = "1.40.43";
in
mkDerivation {
  pname = "qtbitcointrader";
  inherit version;

  src = fetchzip {
    url = "https://github.com/JulyIGHOR/QtBitcoinTrader/archive/v${version}.tar.gz";
    sha256 = "07xbsi78cykpyxidp1bw5ahmymdrs2afg7b0lla7dfhagz18lzxv";
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

  meta = with stdenv.lib; {
    description = "Bitcoin trading client";
    homepage = https://centrabit.com/;
    license = licenses.gpl3;
    platforms = qt5.qtbase.meta.platforms;
    maintainers = [ maintainers.ehmry ];
  };
}
