{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2025-09-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "a5dbb223fc27cc4c7763c977682cfe3b3450d482";
    hash = "sha256-K52Q9KDMgUUY5kmWNuMcZhib5nPdITMt5hXFyDPX+MU=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
