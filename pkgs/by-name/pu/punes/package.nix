{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  cmake,
  pkg-config,
  ffmpeg,
  libGLU,
  alsa-lib,
  libX11,
  libXrandr,
  sndio,
  libsForQt5,
  qt6Packages,
  withQt6 ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "punes";
  version = "0.111";

  src = fetchFromGitHub {
    owner = "punesemu";
    repo = "puNES";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TIXjYkInWV3yVnvXrdHcmeWYeps5TcvkG2Xjg4roIds=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs =
    [
      ffmpeg
      libGLU
      libsForQt5.qtbase
      libsForQt5.qtsvg
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libX11
      libXrandr
    ]
    ++ lib.optionals stdenv.hostPlatform.isBSD [
      sndio
    ];

  cmakeFlags = [
    "-DENABLE_GIT_INFO=OFF"
    "-DENABLE_RELEASE=ON"
    "-DENABLE_FFMPEG=ON"
    "-DENABLE_OPENGL=ON"
    "-DENABLE_QT6_LIBS=OFF"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Qt-based Nintendo Entertainment System emulator and NSF/NSFe Music Player";
    mainProgram = "punes";
    homepage = "https://github.com/punesemu/puNES";
    changelog = "https://github.com/punesemu/puNES/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = with lib.platforms; linux ++ freebsd ++ openbsd ++ windows;
  };
})
