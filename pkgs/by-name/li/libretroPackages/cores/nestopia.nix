{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-10-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "f1e02d12664834536edbf7352995a3d0cd1caef4";
    hash = "sha256-Ezfy+VGCPfxAvXw95CMuvqZHWJ3WYPfbjvHmEp7rjOw=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
