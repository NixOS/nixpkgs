{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-08-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "636a8dd6340bce7073168ddefd29841fc5e2d213";
    hash = "sha256-s2pZ66rLt5aRPpl3J5ZeoGP2sibW7/PYO/ZnjeLjHV8=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
