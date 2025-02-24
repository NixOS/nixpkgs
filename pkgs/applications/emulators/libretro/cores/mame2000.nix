{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2000";
  version = "0-unstable-2024-07-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2000-libretro";
    rev = "2ec60f6e1078cf9ba173e80432cc28fd4eea200f";
    hash = "sha256-AYZj7bvO9oc7wmEBbj6DPRzpQFHl8diIcunSSpD4Vok=";
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
