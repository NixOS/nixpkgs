{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "889e52a07cd93074577bf1b2ea260a2beae7ff7b";
    hash = "sha256-bsSrkYzkUgUxDz0798aB5etJ0er+RtlcdoJY12gB+WY=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
