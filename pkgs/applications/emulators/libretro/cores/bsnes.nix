{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bsnes";
  version = "0-unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bsnes-libretro";
    rev = "d9697514a1901b7fcace0a77a7deccc693db38fb";
    hash = "sha256-PS0Wc9ckVDuXS8bEimlzwXkiz5klAGJrApL04VdDW0A=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of bsnes to libretro";
    homepage = "https://github.com/libretro/bsnes-libretro";
    license = lib.licenses.gpl3Only;
  };
}
