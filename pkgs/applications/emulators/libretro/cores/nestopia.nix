{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-07-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "d0f461cee801c509748606e91c8ff0563ef62cd6";
    hash = "sha256-7SAv7ScyIi/DEEKR1lo8jbjDPUVFsJxj1ot2seCAz1A=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
