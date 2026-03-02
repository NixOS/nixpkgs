{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-02-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "1eee72f640e4da6f1b8ca68f70b51db22cc474c8";
    hash = "sha256-dXCMV0YZy33GcNTYlVTv/x7jwrKJRPTEclfU2qfqlXw=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
