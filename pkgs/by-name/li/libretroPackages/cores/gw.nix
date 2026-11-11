{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gw";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gw-libretro";
    rev = "91d599b951e7bfe7e040347f58667cba20074adc";
    hash = "sha256-YRG16qhTHBpWynPJhrF1RS0ENEOP6kvq1TRdy+GJ478=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Game and Watch to libretro";
    homepage = "https://github.com/libretro/gw-libretro";
    license = lib.licenses.zlib;
  };
}
