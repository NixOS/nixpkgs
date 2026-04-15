{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "meteor";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "meteor-libretro";
    rev = "13ac21ccdb81c8a99fddebf5b29482f19194ec88";
    hash = "sha256-AUn8gTtlFaosKTlcmJCmwdDeEvXwRjkkvht+JXkM36U=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of Meteor to libretro";
    homepage = "https://github.com/libretro/meteor";
    license = lib.licenses.gpl3Only;
  };
}
