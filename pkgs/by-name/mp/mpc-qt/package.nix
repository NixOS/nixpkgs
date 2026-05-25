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
  version = "26.01";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tgCdPzolUlp3Cy1ZbDlMQvl/4WcTl86QTZ8F18f0JME=";
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

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    ignoredVersions = "master";
  };

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
