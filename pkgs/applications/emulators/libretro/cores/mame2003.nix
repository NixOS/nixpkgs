{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003";
  version = "0-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-libretro";
    rev = "c651c573655218428d7c524f611f7d62d13861a1";
    hash = "sha256-7tAmLBClwM6gMILiWN3cIl452EX0JVFtTSEdxPoRs/4=";
  };

  # Fix build with GCC 14
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  makefile = "Makefile";

  meta = {
    description = "Port of MAME ~2003 to libretro, compatible with MAME 0.78 sets";
    homepage = "https://github.com/libretro/mame2003-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
