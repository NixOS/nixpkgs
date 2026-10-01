{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  SDL2,
  sqlite,
  libsForQt5,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "pegasus-frontend";
  version = "0-unstable-2026-10-02";

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "pegasus-frontend";
    rev = "5d58223e58f84afb31d5d14a67438841b981a6fa";
    fetchSubmodules = true;
    hash = "sha256-KfwDt8XhMRF+rnoVClHBIIXE7qG4+ItumlAI73poHLo=";
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
      qtimageformats # required for additional image formats like webp
    ])
    ++ [
      sqlite
      SDL2
    ];

  passthru.updateScript = unstableGitUpdater { };
  __structuredAttrs = true;
  strictDeps = true;

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
