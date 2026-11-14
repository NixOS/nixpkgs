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
  version = "0-unstable-2026-10-29";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "pegasus-frontend";
    rev = "2a13b4f49c5c4a18d308b0cb5e7c99a2e6b8ac9b";
    hash = "sha256-Wc73zfHWnmp1pF7PiRXYq3KbaQmojXufdmFv+d40Swc=";
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
