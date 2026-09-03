{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2000";
  version = "0-unstable-2026-07-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2000-libretro";
    rev = "f099ba44c7664906fd7e01cbed89d13a7e32dee1";
    hash = "sha256-6DhPtvN8CzZl+jJ2ygQdvIJjvjA5Bqjho6KWGyJvOwQ=";
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
