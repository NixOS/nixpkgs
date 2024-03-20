{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
, cmake
, pkg-config
, ffmpeg
, libGLU
, alsa-lib
, libX11
, libXrandr
, sndio
, qtbase
, qtsvg
, qttools
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "punes";
  version = "0.111";

  src = fetchFromGitHub {
    owner = "punesemu";
    repo = "puNES";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TIXjYkInWV3yVnvXrdHcmeWYeps5TcvkG2Xjg4roIds=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    ffmpeg
    libGLU
    qtbase
    qtsvg
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libX11
    libXrandr
  ] ++ lib.optionals stdenv.hostPlatform.isBSD [
    sndio
  ];

  cmakeFlags = [
    "-DENABLE_GIT_INFO=OFF"
    "-DENABLE_RELEASE=ON"
    "-DENABLE_FFMPEG=ON"
    "-DENABLE_OPENGL=ON"
    "-DENABLE_QT6_LIBS=${if lib.versionAtLeast qtbase.version "6.0" then "ON" else "OFF"}"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Qt-based Nintendo Entertainment System emulator and NSF/NSFe Music Player";
    mainProgram = "punes";
    homepage = "https://github.com/punesemu/puNES";
    changelog = "https://github.com/punesemu/puNES/blob/v${finalAttrs.version}/ChangeLog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = with platforms; linux ++ freebsd ++ openbsd ++ windows;
  };
})
