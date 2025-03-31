{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-03-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "b3eb368603cd519d54bb4886d2934ee4fd188081";
    hash = "sha256-gaMZEP+8vCb/b9lhrXcUK4N7v9uxX/FVgnzK48rxyHQ=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
