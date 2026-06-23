{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2026-06-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "93b213d805591c4f1488339c4a16f0b4cb68d44a";
    hash = "sha256-l4HhejwOKE/bk9HFf2mDTDqc223m6UofTIF+BgMIDEw=";
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
