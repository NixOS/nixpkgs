{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-04-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "13e9767dde2938c463e6f8cc4be2149f7d55c3c6";
    hash = "sha256-uj8Mctc0NdUzi5eLtUuMAQwSOd301wa+GQuui7xHnfA=";
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
