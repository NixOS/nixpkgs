{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003-plus";
  version = "0-unstable-2025-01-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-plus-libretro";
    rev = "aee3dac97c72e45b43423349289937dbe2d4a1ce";
    hash = "sha256-X8K536+VfM/WAr4LIhYGWKEt8Oz8GCUMoSqYwQXBQos=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of MAME ~2003+ to libretro, compatible with MAME 0.78 sets";
    homepage = "https://github.com/libretro/mame2003-plus-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
