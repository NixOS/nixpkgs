{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "7f69c199ed88d5723f71dd3a6e9c1b7a45b535a6";
    hash = "sha256-16ZdvG/N31vCC/kI8INH1PkmdfzHhQ2pnrUrzblCayg=";
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
