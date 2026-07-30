{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prboom";
  version = "0-unstable-2026-07-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-prboom";
    rev = "c5b09532fa633e015ac75c0a2acfec049f65ded3";
    hash = "sha256-13oL/U3uwNejqTIbKmITRbK8Eddg9YH5CMDIDXA6zKs=";
  };

  makefile = "Makefile";

  meta = {
    description = "Prboom libretro port";
    homepage = "https://github.com/libretro/libretro-prboom";
    license = lib.licenses.gpl2Only;
  };
}
