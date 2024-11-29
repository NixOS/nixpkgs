{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "freeintv";
  version = "0-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "freeintv";
    rev = "6bd91d0d83d896e66b9fd7e5e239f93f00e4ad87";
    hash = "sha256-P3devj/aAa0e/QpV68kQkLAvhrVGO8O8ijkUAobgUb0=";
  };

  makefile = "Makefile";

  meta = {
    description = "FreeIntv libretro port";
    homepage = "https://github.com/libretro/freeintv";
    license = lib.licenses.gpl3Only;
  };
}
