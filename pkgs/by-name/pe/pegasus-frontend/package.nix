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
  version = "0-unstable-2025-03-02";

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "pegasus-frontend";
    rev = "7d08fdc5578c4cd499d696ea734809185c05a9c1";
    fetchSubmodules = true;
    hash = "sha256-TBdmvCcIKfueTUxMzMvrle5+MRjjs4yDLTpKiQ2WUk0=";
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
      qtimageformats
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
    maintainers = with lib.maintainers; [ tengkuizdihar ];
    platforms = lib.platforms.linux;
  };
}
