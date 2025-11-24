{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "vbam";
  version = "0-unstable-2025-11-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vbam-libretro";
    rev = "d0787aee43d260675da203c2f85ba9fa226c0c66";
    hash = "sha256-WhsiKsDk7jEIklrOw1YFCcWSlAmLK4vCCji3Mnsgwmw=";
  };

  makefile = "Makefile";
  preBuild = "cd src/libretro";

  meta = {
    description = "VBA-M libretro port";
    homepage = "https://github.com/libretro/vbam-libretro";
    license = lib.licenses.gpl2Only;
  };
}
