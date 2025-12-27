{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  boost,
  qt6Packages,
  mpv,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpc-qt";
  version = "25.07-master";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gPDwHT0QSgjfGhRMTa4DhjNMDrlaA34X8hw0t/6AKLA=";
  };

  nativeBuildInputs = [
    boost
    ninja
    cmake
    pkg-config
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    mpv
  ];

  cmakeFlags = [
    "-DMPCQT_VERSION=${finalAttrs.version}"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Media Player Classic Qute Theater";
    homepage = "https://mpc-qt.github.io";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ romildo ];
    mainProgram = "mpc-qt";
  };
})
