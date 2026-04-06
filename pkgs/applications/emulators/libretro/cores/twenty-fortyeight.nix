{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "2048";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-2048";
    rev = "1892de39d80ec37e1fac79729cd91917b21f1349";
    hash = "sha256-lNcDdkiWiXhvwwpzMnceTDY+mJl1JTZfGCY+WIOvrP8=";
  };

  meta = {
    description = "Port of 2048 puzzle game to libretro";
    homepage = "https://github.com/libretro/libretro-2048";
    license = lib.licenses.unlicense;
  };
}
