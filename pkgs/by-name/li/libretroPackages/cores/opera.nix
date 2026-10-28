{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-10-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "684926fe2079ba12b59d99082291c0a8fe780c67";
    hash = "sha256-c1z5bXKn+bcakhoN6u3pXbvLLjd7xHf4kIJl6ZoWJhE=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
