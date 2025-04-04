{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttr: {
  pname = "qtbitcointrader";
  version = "1.42.21";

  src = fetchFromGitHub {
    owner = "JulyIGHOR";
    repo = "QtBitcoinTrader";
    tag = "v${finalAttr.version}";
    hash = "sha256-u3+Kwn8KunYUpWCd55TQuVVfoSp8hdti93d6hk7Uqx8=";
  };

  nativeBuildInputs = [ libsForQt5.wrapQtAppsHook ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    libsForQt5.qtscript
  ];

  sourceRoot = "${finalAttr.src.name}/src";

  configurePhase = ''
    runHook preConfigure

    qmake $qmakeFlags \
      PREFIX=$out \
      DESKTOPDIR=$out/share/applications \
      ICONDIR=$out/share/pixmaps \
      QtBitcoinTrader_Desktop.pro

    runHook postConfigure
  '';

  meta = {
    description = "Bitcoin trading client";
    mainProgram = "QtBitcoinTrader";
    homepage = "https://centrabit.com/";
    license = lib.licenses.gpl3;
    platforms = libsForQt5.qtbase.meta.platforms;
  };
})
