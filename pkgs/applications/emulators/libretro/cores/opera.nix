{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2025-12-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "345f12b7d45d7013602a4a3b72287f529bd78042";
    hash = "sha256-2FkBsiKOzf/sMtKA1vI0ixWP9/ghs/N7zA7/m6h6gZ0=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
