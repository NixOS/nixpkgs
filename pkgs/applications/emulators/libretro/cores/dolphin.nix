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
  version = "0-unstable-2024-04-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "dolphin";
    rev = "89a4df725d4eb24537728f7d655cddb1add25c18";
    hash = "sha256-f9O3//EuoCSPQC7GWmf0EzAEpjoKof30kIDBCDw0dbs=";
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
