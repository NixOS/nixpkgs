{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003";
  version = "0-unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-libretro";
    rev = "8f17f5f4cb432c5d2d2771e5a76f8c4eac2d31a6";
    hash = "sha256-yXII81KiO+53/S2p9H5/81fyCf1qKauQTVjlfNOwu3s=";
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
