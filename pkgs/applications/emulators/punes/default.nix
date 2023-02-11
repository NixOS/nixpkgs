{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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

stdenv.mkDerivation rec {
  pname = "punes";
  version = "0.110";

  src = fetchFromGitHub {
    owner = "punesemu";
    repo = "puNES";
    rev = "v${version}";
    sha256 = "sha256-+hL168r40aYUjyLbWFXWk9G2srrrG1TH1gLYMliHftU=";
  };

  patches = [
    # Fixes compilation on aarch64
    # Remove when version > 0.110
    (fetchpatch {
      url = "https://github.com/punesemu/puNES/commit/90dd5bc90412bbd199c2716f67a24aa88b24d80f.patch";
      hash = "sha256-/KNpTds4qjwyaTUebWWPlVXfuxVh6M4zOInxUfYztJg=";
    })
  ];

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
    homepage = "https://github.com/punesemu/puNES";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = with platforms; linux ++ freebsd ++ openbsd ++ windows;
  };
}
