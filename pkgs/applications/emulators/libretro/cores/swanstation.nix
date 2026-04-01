{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2026-03-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "9498be27f8cdde1244045ee7bd6f11922a8f7916";
    hash = "sha256-+8CcxNl6s7/St4aRf3a1LTsl8wRTIhAYIaAGCt/HbtU=";
  };

  extraNativeBuildInputs = [ cmake ];
  makefile = "Makefile";
  cmakeFlags = [
    "-DBUILD_LIBRETRO_CORE=ON"
  ];

  meta = {
    description = "Port of SwanStation (a fork of DuckStation) to libretro";
    homepage = "https://github.com/libretro/swanstation";
    license = lib.licenses.gpl3Only;
  };
}
