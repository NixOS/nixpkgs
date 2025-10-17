{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2003-plus";
  version = "0-unstable-2025-09-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2003-plus-libretro";
    rev = "59b8a9fb06a47a3ce6aecd09b07f3f001e3d9b08";
    hash = "sha256-hfC/6UqUSDd2FWpcCVcw4pkAtyHJGCgvG4UKlkM+fpk=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of MAME ~2003+ to libretro, compatible with MAME 0.78 sets";
    homepage = "https://github.com/libretro/mame2003-plus-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
