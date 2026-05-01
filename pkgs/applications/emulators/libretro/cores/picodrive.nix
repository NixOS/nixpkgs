{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2025-11-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "046e5ff91eb4bfa728e51e01304ff73cf6b4ee96";
    hash = "sha256-uoUqap7hMg8C2Ouud0UTtkWeZbtga9GVqSipHZK90/s=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
