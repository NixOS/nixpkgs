{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-11-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "349bc90ce4963b73120104590b3d6d893c9df8ce";
    hash = "sha256-Efv9JJ7jjWKXHVK2cr3xWFaFTmTdRR/3BOYQdOk7rPo=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
