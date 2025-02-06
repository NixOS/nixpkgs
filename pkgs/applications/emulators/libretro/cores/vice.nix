{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-01-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "cdef1f9f8d5cbe4ba3e9b9106e117bdd35f599b9";
    hash = "sha256-02ZH5ax49uWnvYe+hpL7a94Bf8knja1YADxyI2irYms=";
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
