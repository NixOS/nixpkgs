{
  lib,
  alsa-lib,
  fetchFromGitHub,
  mkLibretroCore,
  python3,
}:
mkLibretroCore {
  core = "mame2015";
  version = "0-unstable-2026-09-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2015-libretro";
    rev = "7adbf440d5f554097f58f8c6ebb673adc4320a31";
    hash = "sha256-H11R/8JgBRISTHBxrXSiPSxY2a/P2xdbDXPwpyf6dBQ=";
  };

  makeFlags = [ "PYTHON=python3" ];
  extraNativeBuildInputs = [ python3 ];
  extraBuildInputs = [ alsa-lib ];
  makefile = "Makefile";
  # Build failures when this is set to a bigger number
  env.NIX_BUILD_CORES = 8;

  meta = {
    description = "Port of MAME ~2015 to libretro, compatible with MAME 0.160 sets";
    homepage = "https://github.com/libretro/mame2015-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
