{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-06-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "4f53f97418f72bbefefff8d5746aa49942fc9848";
    hash = "sha256-P8UN3r7clkwY7OD5iQKjLys55q+tfpAVl8abhKj3ZOc=";
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
