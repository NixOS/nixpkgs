{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  imagemagick,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtbitcointrader";
  version = "1.42.21";

  src = fetchFromGitHub {
    owner = "JulyIGHOR";
    repo = "QtBitcoinTrader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u3+Kwn8KunYUpWCd55TQuVVfoSp8hdti93d6hk7Uqx8=";
  };

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux imagemagick;

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    libsForQt5.qtscript
  ];

  sourceRoot = "${finalAttrs.src.name}/src";

  configurePhase = ''
    runHook preConfigure

    qmake $qmakeFlags \
      PREFIX=$out \
      DESKTOPDIR=$out/share/applications \
      ICONDIR=$out/share/icons/hicolor/1024x1024/apps \
      QtBitcoinTrader_Desktop.pro

    runHook postConfigure
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    mkdir -p $out/share/icons/hicolor/512x512/apps
    magick convert QtBitcoinTrader.png -resize 512x512 $out/share/icons/hicolor/512x512/apps/QtBitcoinTrader.png
  '';

  meta = {
    description = "Bitcoin trading client";
    mainProgram = "QtBitcoinTrader";
    homepage = "https://centrabit.com/";
    license = lib.licenses.gpl3;
    platforms = libsForQt5.qtbase.meta.platforms;
  };
})
