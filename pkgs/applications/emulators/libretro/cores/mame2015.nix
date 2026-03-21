{
  lib,
  alsa-lib,
  fetchFromGitHub,
  mkLibretroCore,
  python3,
}:
mkLibretroCore {
  core = "mame2015";
  version = "0-unstable-2023-10-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2015-libretro";
    rev = "316cd06349f2b34b4719f04f7c0d07569a74c764";
    hash = "sha256-CBN04Jf26SIk8mKWlui5spQGokBvgFUCvFiC8NoBGw0=";
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
