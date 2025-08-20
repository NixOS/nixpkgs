{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2024-07-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "37cd87e14ca09ac1b558e5b2c7db4ad256865bbb";
    hash = "sha256-dNIxlTPoY4S6VMtTN22ti3DE4aU/8XN/XhAo3DMNR/E=";
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
