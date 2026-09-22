{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  SDL2,
  sqlite,
  libsForQt5,
}:

stdenv.mkDerivation {
  pname = "pegasus-frontend";
  version = "0-unstable-2026-07-18";

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "pegasus-frontend";
    rev = "6b322063a036db60cba5810fda82a3ce38f1e62f";
    fetchSubmodules = true;
    hash = "sha256-HsOli+iU9DjTrFSjBENiIURCXQcazB9QWrti7VszNvE=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs =
    (with libsForQt5; [
      qtbase
      qtmultimedia
      qtsvg
      qtgraphicaleffects
      qtx11extras
    ])
    ++ [
      sqlite
      SDL2
    ];

  meta = {
    description = "Cross platform, customizable graphical frontend for launching emulators and managing your game collection";
    mainProgram = "pegasus-fe";
    homepage = "https://pegasus-frontend.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      tengkuizdihar
      irgolic
    ];
    platforms = lib.platforms.linux;
  };
}
