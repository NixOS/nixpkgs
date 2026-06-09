{
  lib,
  alsa-lib,
  fetchFromGitHub,
  mkLibretroCore,
  python3,
}:
mkLibretroCore {
  core = "mame2015";
  version = "0-unstable-2026-04-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2015-libretro";
    rev = "b0cd015f4de7a3979374ab70613db65415e99477";
    hash = "sha256-EyXnHzSbLD2yAGISX8obpAUM4toVobBxM/b/Fx1F9xY=";
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
