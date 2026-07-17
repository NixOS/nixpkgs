{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-07-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "1edda8a2a6c6b9ae259d5c7cd7d54dcba9ee7e32";
    hash = "sha256-dc7xRjFxfSL2q9u1N0QH2j+oPbRGng2Z3U3J484lXiU=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
