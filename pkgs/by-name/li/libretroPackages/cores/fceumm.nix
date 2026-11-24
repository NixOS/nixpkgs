{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2026-11-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "fb919fb6fa881aaa6279b765d480220579e5c606";
    hash = "sha256-bK1f76/J0zdwTFlKc2Hs0bETDhT/SZf4E7WfYM6C1cM=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
