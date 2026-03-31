{
  lib,
  alsa-lib,
  fetchFromGitHub,
  mkLibretroCore,
  python3,
}:
mkLibretroCore {
  core = "mame2015";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2015-libretro";
    rev = "48fdf6532f31e3bb8b58b9ae10198b047cd8de42";
    hash = "sha256-z/SjAx615RZUOytoDPFFXl89E5063cbc0OFIV2/HZBo=";
  };

  patches = [ ./patches/mame2015-python311.patch ];
  makeFlags = [ "PYTHON=python3" ];
  extraNativeBuildInputs = [ python3 ];
  extraBuildInputs = [ alsa-lib ];
  makefile = "Makefile";
  # Build failures when this is set to a bigger number
  NIX_BUILD_CORES = 8;
  meta = {
    description = "Port of MAME ~2015 to libretro, compatible with MAME 0.160 sets";
    homepage = "https://github.com/libretro/mame2015-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
