{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-07-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "0e9562eb2e2628fb4fc5d7180fd7125631da7fd4";
    hash = "sha256-yz1pOn8S8l4FeMXOpaqdBnZETcr1iKFTOcCTyNEjVS8=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
