{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003-plus";
  version = "0-unstable-2026-08-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-plus-libretro";
    rev = "21256d24120b04916c5197d95b757635ca880fd9";
    hash = "sha256-Ct2oxXd3BPC7kVbpqTFrRT+B/25dGrOpkvFN6JhSx9E=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of MAME ~2003+ to libretro, compatible with MAME 0.78 sets";
    homepage = "https://github.com/libretro/mame2003-plus-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
