{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-04-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "4c4ca6bf741c40715723a8b8dae4b6187ff6ac30";
    hash = "sha256-AcuqEuK3bz+WJ0r723+w6Y9WGuNs04zUOWlQ3aMXk/U=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
