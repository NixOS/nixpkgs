{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  ffmpeg,
  libjack2,
  libx11,
  libxext,
  libxinerama,
  libxfixes,
  libGLU,
  libGL,
  pkg-config,
  libpulseaudio,
  libv4l,
  pipewire,
  libsForQt5,
  cmake,
  ninja,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "simplescreenrecorder";
  version = "0.4.4-unstable-2026-05-23";

  src = fetchFromGitHub {
    owner = "MaartenBaert";
    repo = "ssr";
    rev = "ad99c7e855794888101aea2f119cdab1d4aa3073";
    hash = "sha256-Slfte4K1VEUWIWFp7D49SRNEMZY+VVHTWzf966MUR4E=";
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
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    ffmpeg
    libjack2
    libx11
    libxext
    libxfixes
    libxinerama
    libGLU
    libGL
    libpulseaudio
    libv4l
    pipewire
    libsForQt5.qtbase
    libsForQt5.qttools
    libsForQt5.qtx11extras
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Screen recorder for Linux";
    homepage = "https://www.maartenbaert.be/simplescreenrecorder";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
