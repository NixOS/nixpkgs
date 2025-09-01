{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2025-08-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "143b0abb02a6ff501757674c9fdf47e0fcd7cbd3";
    hash = "sha256-XdcoM0hzVvuZZn7kXh1X8HSUGGEm/0Uqh7du7nx4sIE=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
