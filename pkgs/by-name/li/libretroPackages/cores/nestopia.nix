{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "92578fdc9445f61dd376138329a938e01d8ba50e";
    hash = "sha256-PBBSAz6hMioHZTOeAspoxjf7Cz/bcr3ppEYqkGcIlz4=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
