{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-02-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "cd9b682b02c4ac3e3516acb4a1b6011bf1676c79";
    hash = "sha256-7tqzsvbiwA8i1t+IjYuwFvg/BvoOy5WHjESCbzcj9jM=";
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
