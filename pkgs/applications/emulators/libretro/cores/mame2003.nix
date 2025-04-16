{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003";
  version = "0-unstable-2025-04-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-libretro";
    rev = "a0547e84a8f58856551ca2d252f05f56212810a4";
    hash = "sha256-POpKNpPOyOp/EkrUTa2esOJAaWoJvuijDToF6/V41uU=";
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
