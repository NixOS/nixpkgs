{
  lib,
  fetchFromGitHub,
  qt5,
  mkDerivation,
}:

mkDerivation rec {
  pname = "qtbitcointrader";
  version = "1.40.43";

  src = fetchFromGitHub {
    owner = "JulyIGHOR";
    repo = "QtBitcoinTrader";
    rev = "v${version}";
    sha256 = "sha256-u3+Kwn8KunYUpWCd55TQuVVfoSp8hdti93d6hk7Uqx8=";
  };

  buildInputs = [
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qtscript
  ];

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

  meta = with lib; {
    description = "Bitcoin trading client";
    mainProgram = "QtBitcoinTrader";
    homepage = "https://centrabit.com/";
    license = licenses.gpl3;
    platforms = qt5.qtbase.meta.platforms;
  };
}
