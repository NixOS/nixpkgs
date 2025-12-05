{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2025-08-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "4d309c05fd7bdc503d91d267bd542edb8d192b09";
    hash = "sha256-v51xgsyVtyipss0VWqMTI69MLTJ4Eb37hJfbQfid/0Q=";
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
