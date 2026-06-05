{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "meteor";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "meteor-libretro";
    rev = "77658235b09979850bb9f89298cfc6c6504f0e14";
    hash = "sha256-l/m8HmKnOt/zJ8V+IBqKYc2UZaRBQiaqkpzUPZnKOd0=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of Meteor to libretro";
    homepage = "https://github.com/libretro/meteor";
    license = lib.licenses.gpl3Only;
  };
}
