{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2026-10-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "631f0fb31b809e0f889d7c551fe695788e39c1d3";
    hash = "sha256-m6ImnlrdWplX6aRektSve+vHkCJ1nY7bnqQPYSY0+c8=";
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
