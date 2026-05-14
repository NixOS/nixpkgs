{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-04-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "626ee68726035e0bec8c05b702ed3cb378daf4f5";
    hash = "sha256-vOZ6EEaJWdMZKIlF7oi3MKkLMjjJfVD1+yxOW+/ZNmU=";
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
