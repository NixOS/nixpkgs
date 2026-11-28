{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  inherit (qt6)
    qmake
    qtbase
    qtwebengine
    qtwebchannel
    qtpositioning
    qtsvg
    wrapQtAppsHook
    ;
in
stdenv.mkDerivation rec {
  pname = "kleiner-brauhelfer-2";
  version = "2.6.2-unstable-2024-12-08";

  src = fetchFromGitHub {
    owner = "kleiner-brauhelfer";
    repo = "kleiner-brauhelfer-2";
    rev = "9302975bc9af170134be6918c60d9566b6ed18a9";
    hash = "sha256-gP046NWc/LRLvZBxEH1wTsSe8z5KDYaBZI2B5+TgeGw=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    qtbase
    qtwebengine
    qtwebchannel
    qtpositioning
    qtsvg
  ];

  qmakeFlags = [
    "CONFIG+=release"
    "kleiner-brauhelfer-2.pro"
  ];

  # upstream desktop file is only German
  desktopItems = [
    (makeDesktopItem {
      name = "kleiner-brauhelfer-2";
      exec = "kleiner-brauhelfer-2";
      icon = "kleiner-brauhelfer-2";
      desktopName = "Kleiner Brauhelfer 2";
      genericName = "Brewing Software";
      comment = "Brewing software for home brewers to create and manage beer batches";
      categories = [ "Utility" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/icons}
    install -Dm755 bin/kleiner-brauhelfer-2 $out/bin/kleiner-brauhelfer-2
    install -Dm644 kleiner-brauhelfer/images/logo.svg $out/share/icons/kleiner-brauhelfer-2.svg

    runHook postInstall
  '';

  meta = {
    description = "Brewing software for home brewers to create and manage beer batches";
    homepage = "https://kleiner-brauhelfer.de";
    changelog = "https://github.com/kleiner-brauhelfer/kleiner-brauhelfer-2/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    mainProgram = "kleiner-brauhelfer-2";
    maintainers = with lib.maintainers; [ yeoldegrove ];
    platforms = lib.platforms.linux;
  };
}
