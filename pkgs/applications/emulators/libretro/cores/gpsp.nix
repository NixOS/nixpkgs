{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2025-09-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "a545aafaf4e654a488f4588f4f302d8413a58066";
    hash = "sha256-94J5WqlvBgfF/0aj0Pu61psG5pbhJVsZOiIbMdZ+ryQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
