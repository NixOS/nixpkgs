{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-05-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "86bcfa8c4839236f70e31c656d220c074ff1dfb0";
    hash = "sha256-Dw+dY1IsR5cIzXa61bWO+2GhrYqgC2ASMjxQe2MVeco=";
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
