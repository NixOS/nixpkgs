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

let
  qtPackages = if withQt6 then qt6Packages else libsForQt5;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "punes";
  version = "0.111";

  src = fetchFromGitHub {
    owner = "punesemu";
    repo = "puNES";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TIXjYkInWV3yVnvXrdHcmeWYeps5TcvkG2Xjg4roIds=";
  };

  patches = [
    # Fix FTBFS with Qt 6.7.1
    # Remove when version > 0.111
    (fetchpatch {
      name = "0001-punes-Fix-compatibility-with-Qt-6.7.1.patch";
      url = "https://github.com/punesemu/puNES/commit/6e51b1a6107ad3de97edd40ae4ec2d41b32d804f.patch";
      hash = "sha256-xRalKIOb1qWgqJsFLcm7uUOblEfHDYbkukmcr4/+4Qc=";
    })

    # Fix FTBFS with Qt 6.9
    # Remove when version > 0.111
    (fetchpatch {
      name = "0002-punes-Updated-code-for-Qt-6.9.0-compatibility.patch";
      url = "https://github.com/punesemu/puNES/commit/ff906e0a79eeac9a2d16783e0accf65748bb275e.patch";
      hash = "sha256-+s7AdaUBgCseQs6Mxat/cDmQ77s6K6J0fUfyihP82jM=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ (with qtPackages; [
    qttools
    wrapQtAppsHook
  ]);

  buildInputs = [
    ffmpeg
    libGLU
  ]
  ++ (with qtPackages; [
    qtbase
    qtsvg
  ])
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
    (lib.strings.cmakeBool "ENABLE_QT6_LIBS" withQt6)
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
