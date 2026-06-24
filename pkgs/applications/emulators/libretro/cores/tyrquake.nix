{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "tyrquake";
  version = "0-unstalble-2026-05-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "tyrquake";
    rev = "5c09044ee01770610fbeafaceeb1d49453b6bf4f";
    hash = "sha256-mnITyEGvjLuOFKwzeoCUYg1KxEbWSbVUuldRqfRbYrQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Libretro port of Tyrquake which is a Quake 1 engine";
    homepage = "https://github.com/libretro/tyrquake";
    license = lib.licenses.gpl2Only;
  };
}
