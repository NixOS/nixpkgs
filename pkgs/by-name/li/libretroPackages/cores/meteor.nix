{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "meteor";
  version = "0-unstable-2026-09-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "meteor-libretro";
    rev = "9ea6c358eae6acd1a346647d96b832ccaffad0aa";
    hash = "sha256-FjKvitl2KCVMyLcrUbjPhJS6E/nFY1hQj29ZI7ubjdg=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of Meteor to libretro";
    homepage = "https://github.com/libretro/meteor";
    license = lib.licenses.gpl3Only;
  };
}
