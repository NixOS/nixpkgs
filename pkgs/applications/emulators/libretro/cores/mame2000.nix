{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2000";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2000-libretro";
    rev = "cee538f9b28f00039f298cb3c2b588203f07d0be";
    hash = "sha256-QgVLa6ZgyHWZeWRTemrzQW3hFYA+H+/twsghvlf/Z4c=";
  };

  makefile = "Makefile";
  makeFlags = lib.optional (!stdenv.hostPlatform.isx86) "IS_X86=0";

  meta = {
    description = "Port of MAME ~2000 to libretro, compatible with MAME 0.37b5 sets";
    homepage = "https://github.com/libretro/mame2000-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
