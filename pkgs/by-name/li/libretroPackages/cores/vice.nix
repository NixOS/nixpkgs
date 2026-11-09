{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-10-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "f63b56688f3133a2bb17499db9eebb7ab81df5f5";
    hash = "sha256-c0p/id/imkmau/9X6MwomjBSBZ1sbYqv8sJ8NpJuz+g=";
  };

  makefile = "Makefile";

  env = {
    EMUTYPE = "${type}";
  };

  meta = {
    description = "Port of vice to libretro";
    homepage = "https://github.com/libretro/vice-libretro";
    license = lib.licenses.gpl2;
  };
}
