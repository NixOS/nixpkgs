{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  copyDesktopItems,
  inih,
  libsForQt5,
  makeDesktopItem,
  ninja,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "qzdl";
  version = "3.3.0.0-unstable-2025-01-04";

  src = fetchFromGitHub {
    owner = "qbasicer";
    repo = "qzdl";
    rev = "a03191777152b932b9bf15f45d439bf38e8c7679";
    hash = "sha256-YRWJBuYY1QI/liiGw5zYFqsrK+DyvW1Lpava6CkmVnQ=";
  };

  patches = [
    ./cmake.patch
  ];

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    inih
    libsForQt5.qtbase
  ];

  postInstall = ''
    install -Dm644 $src/res/zdl3.svg $out/share/icons/hicolor/scalable/apps/zdl3.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "zdl3";
      exec = "zdl %U";
      icon = "zdl3";
      desktopName = "ZDL";
      genericName = "A ZDoom WAD Launcher";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "ZDoom WAD Launcher";
    homepage = "https://zdl.vectec.net";
    license = lib.licenses.gpl3Only;
    inherit (libsForQt5.qtbase.meta) platforms;
    maintainers = [ lib.maintainers.azahi ];
    mainProgram = "zdl";
  };
}
