{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2026-05-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "0f7757b3196ab472c3a8b279206b3ea19a3e5f2d";
    hash = "sha256-5R+K0NpLdjajT6LV0os569vrgqRCtfXDqMnhM8z7dmk=";
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
