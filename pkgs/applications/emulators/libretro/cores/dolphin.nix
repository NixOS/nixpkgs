{
  lib,
  fetchFromGitHub,
  cmake,
  curl,
  gettext,
  hidapi,
  libGL,
  libGLU,
  libevdev,
  mkLibretroCore,
  pcre,
  pkg-config,
  sfml,
  udev,
  xorg,
}:
mkLibretroCore {
  core = "dolphin";
  version = "0-unstable-2025-08-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "dolphin";
    rev = "83438f9b1a2c832319876a1fda130a5e33d4ef87";
    hash = "sha256-q4y+3uJ1tQ2OvlEvi/JNyIO/RfuWNIEKfVZ6xEWKFCg=";
  };

  extraNativeBuildInputs = [
    cmake
    curl
    pkg-config
  ];
  extraBuildInputs = [
    gettext
    hidapi
    libGL
    libGLU
    libevdev
    pcre
    sfml
    udev
    xorg.libSM
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXxf86vm
    xorg.libpthreadstubs
    xorg.libxcb
    xorg.xcbutil
  ];

  makefile = "Makefile";
  cmakeFlags = [
    "-DLIBRETRO=ON"
    "-DLIBRETRO_STATIC=1"
    "-DENABLE_QT=OFF"
    "-DENABLE_LTO=OFF"
    "-DUSE_UPNP=OFF"
    "-DUSE_DISCORD_PRESENCE=OFF"
  ];
  dontUseCmakeBuildDir = true;

  meta = {
    description = "Port of Dolphin to libretro";
    homepage = "https://github.com/libretro/dolphin";
    license = lib.licenses.gpl2Plus;
  };
}
