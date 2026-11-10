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
  version = "0-unstable-2026-10-26";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "pegasus-frontend";
    rev = "cf28a1b7cf20c975b171d0bf7fd68be8a3d70d21";
    hash = "sha256-jGMQb59ApfxHdgLF7lohpFybsqgSF3u6PnNHnIxHFpE=";
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
