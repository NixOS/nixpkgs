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
  qtx11extras,
  libxfixes,
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
  version = "0.4.4-unstable-2025-12-28";

  src = fetchFromGitHub {
    owner = "MaartenBaert";
    repo = "ssr";
    rev = "d790385b49de937976165d6feb39414c75ad6a3d";
    hash = "sha256-QfFK43iwtwZvTRbxNXiphcsxhn/ofllGX993XppiRBw=";
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
    libx11
    libxext
    libxfixes
    libxinerama
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

  meta = {
    description = "Screen recorder for Linux";
    homepage = "https://www.maartenbaert.be/simplescreenrecorder";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
