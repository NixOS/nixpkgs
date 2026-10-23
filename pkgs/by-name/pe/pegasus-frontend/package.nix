{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  cmake,
  libsForQt5,
  sqlite,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pegasus-frontend";
  version = "0-unstable-2026-10-02";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "pegasus-frontend";
    rev = "5d58223e58f84afb31d5d14a67438841b981a6fa";
    hash = "sha256-KfwDt8XhMRF+rnoVClHBIIXE7qG4+ItumlAI73poHLo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtgraphicaleffects
    libsForQt5.qtimageformats # required for additional image formats like webp
    libsForQt5.qtmultimedia
    libsForQt5.qtsvg
    libsForQt5.qtwayland
    SDL2
    sqlite
  ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Cross platform, customizable graphical frontend for launching emulators and managing your game collection";
    homepage = "https://pegasus-frontend.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      tengkuizdihar
      irgolic
      xelacodes
    ];
    platforms = lib.platforms.linux;
    mainProgram = "pegasus-fe";
  };
})
