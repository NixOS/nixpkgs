{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "o2em";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-o2em";
    rev = "e03d3be88f79fe940b933e53f1515d97313f6c59";
    hash = "sha256-OSW81RXyXbv4s6hGDdQwE0FEk6xeeA0SM3d47M+mQVw=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of O2EM to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.artistic1;
  };
}
