{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prboom";
  version = "0-unstable-2026-09-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-prboom";
    rev = "d20300de2d32e5b8e8b0a0f15b1e1a889583d248";
    hash = "sha256-56A6JEOoorKi2yitpVk+iXCzZLAkjzYM3jcxPqOtuXE=";
  };

  makefile = "Makefile";

  meta = {
    description = "Prboom libretro port";
    homepage = "https://github.com/libretro/libretro-prboom";
    license = lib.licenses.gpl2Only;
  };
}
