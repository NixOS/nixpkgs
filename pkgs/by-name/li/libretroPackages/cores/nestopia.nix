{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-09-25";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "8f00f500912a847062de432e38765c7285483e62";
    hash = "sha256-xUOH7Dbm1BW+sCUFOCP6lJnWYi9dMlCRHbYU1ngvYkM=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
