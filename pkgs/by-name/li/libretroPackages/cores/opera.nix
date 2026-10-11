{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-08-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "a501a278d057b952d1ad6165549c59ab178ca497";
    hash = "sha256-eDZ11SD6ZMeXfRZk24uIM/96t7bXVnSTzHmjRiSwuU0=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
