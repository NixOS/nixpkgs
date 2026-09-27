{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2026-09-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "b6c30a7b270a3f68ac41f268eafdfa678d17dea2";
    hash = "sha256-b/vrvb23QOkZJb6GIpNxwYu5SpJ0s1NjdSAFJlcQMk0=";
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
