{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003-plus";
  version = "0-unstable-2026-04-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-plus-libretro";
    rev = "3da943f4bcf264c7af83a07b78617e98ce3822cd";
    hash = "sha256-3hJj8BLePPdEEsQriHSWhIMhamr7pvpKswP5/RxtjcM=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of MAME ~2003+ to libretro, compatible with MAME 0.78 sets";
    homepage = "https://github.com/libretro/mame2003-plus-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
