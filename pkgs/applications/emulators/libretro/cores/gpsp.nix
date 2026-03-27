{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2026-01-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "602512d7c687acb84cd56265cbcf2d7b7c75fb37";
    hash = "sha256-YloLG2anJJ1hcVltN+d8XsshgZoDBrFRgRoQA7mfhN8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
