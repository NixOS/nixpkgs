{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2025-05-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "05cee5f56c37eaa3a243e0906d2082b025598056";
    hash = "sha256-Cwf6hZKl+rE00C0rFq7VhTj3qG4rszQ+8qZQMZ+H7e8=";
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
