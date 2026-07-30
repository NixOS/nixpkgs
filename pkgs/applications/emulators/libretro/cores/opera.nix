{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "74dd2a8c6319678ffce9f31bdf36279db5681762";
    hash = "sha256-NHXOfKItLkQJ0/jH1gLBpLFqOKBB8qgH5gMw7j1YoLw=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
