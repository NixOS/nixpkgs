{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2026-10-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "e436e9b85374def58d211df7f78880f0f4a917b4";
    hash = "sha256-4WeqOmsFC3kQYC+3L5aapj/79TRLWZYWmUyDxCfwZl4=";
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
