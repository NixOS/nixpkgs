{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "78a662e3135871a6c657d5e61900f6704152e594";
    hash = "sha256-3+x1ILIUq+/nwfUGXweNIq3PFTAaP56/6G+dX4dEZ/Y=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
