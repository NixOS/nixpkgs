{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003-plus";
  version = "0-unstable-2025-06-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-plus-libretro";
    rev = "04fb75e4f1291a490574168f3a04f9455e4a008d";
    hash = "sha256-dMfLK47DojJwSvd7KMW0D0azgQalRW8mBJqYJHTA6ew=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of MAME ~2003+ to libretro, compatible with MAME 0.78 sets";
    homepage = "https://github.com/libretro/mame2003-plus-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
