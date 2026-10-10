{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-10-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "ee0273a8f60e7c21fc7f679bb9c95ad1652b37cd";
    hash = "sha256-DxRkpagusVGO4doLraFvHcOxpQSwMamKZDUqJ4eJqcU=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
