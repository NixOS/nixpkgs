{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-09-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "9d7983826ea792f6cce7fdfe6c09488129c6f886";
    hash = "sha256-+052OnC/iPMI09vcP5XTTxnQuwBgDmZ6Ua/d9AEQjUY=";
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
