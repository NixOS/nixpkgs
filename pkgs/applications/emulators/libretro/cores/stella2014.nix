{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella2014";
  version = "0-unstable-2026-04-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "stella2014-libretro";
    rev = "eed47e154d1bbda3305e9ef2d486b6710c8973f4";
    hash = "sha256-QpPjVnFCkn6xlB7LxpE6bsNfYe3HSsEKUjqmEf2yTvA=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Stella ~2014 to libretro";
    homepage = "https://github.com/libretro/stella2014-libretro";
    license = lib.licenses.gpl2Only;
  };
}
