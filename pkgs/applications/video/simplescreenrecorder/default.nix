{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  ffmpeg,
  libjack2,
  libX11,
  libXext,
  libXinerama,
  qtx11extras,
  libXfixes,
  libGLU,
  libGL,
  pkg-config,
  libpulseaudio,
  libv4l,
  pipewire,
  qtbase,
  qttools,
  wrapQtAppsHook,
  cmake,
  ninja,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "simplescreenrecorder";
  version = "0.4.4-unstable-2025-01-25";

  src = fetchFromGitHub {
    owner = "MaartenBaert";
    repo = "ssr";
    rev = "c50e83eea53f45eff503af58e6c86d0e928222f3";
    hash = "sha256-pTgIooEOIYwOrSuXD0L5S7J7IsUIyzRuEX2ZziiIiAM=";
  };

  cmakeFlags = [
    "-DWITH_QT5=TRUE"
    "-DWITH_GLINJECT=${if stdenv.hostPlatform.isx86 then "TRUE" else "FALSE"}"
  ];

  postPatch = ''
    substituteInPlace scripts/ssr-glinject \
      --replace-fail "libssr-glinject.so" "$out/lib/libssr-glinject.so"

    substituteInPlace src/AV/Input/GLInjectInput.cpp \
      --replace-fail "/bin/sh" "${stdenv.shell}" \
      --replace-fail "libssr-glinject.so" "$out/lib/libssr-glinject.so"
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    ffmpeg
    libjack2
    libX11
    libXext
    libXfixes
    libXinerama
    libGLU
    libGL
    libpulseaudio
    libv4l
    pipewire
    qtbase
    qttools
    qtx11extras
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Screen recorder for Linux";
    homepage = "https://www.maartenbaert.be/simplescreenrecorder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
