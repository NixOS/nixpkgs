{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2026-07-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "5430a4a53b89fa5827c97b84ada29d23317245bc";
    hash = "sha256-sE9jJjdt25nz0+B0oSonRubYWurE20o/FDdUTj//qOI=";
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
