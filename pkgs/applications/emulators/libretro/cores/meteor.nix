{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "meteor";
  version = "0-unstable-2020-12-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "meteor-libretro";
    rev = "e533d300d0561564451bde55a2b73119c768453c";
    hash = "sha256-zMkgzUz2rk0SD5ojY4AqaDlNM4k4QxuUxVBRBcn6TqQ=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of Meteor to libretro";
    homepage = "https://github.com/libretro/meteor";
    license = lib.licenses.gpl3Only;
  };
}
