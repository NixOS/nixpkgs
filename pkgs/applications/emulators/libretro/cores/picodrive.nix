{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2024-10-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "0daf92b57fba1fdbc124651573e88373eef28aa5";
    hash = "sha256-rvgcGNpHhjHpg5q6qiu08lBn+Zjx87E5/Q98gPoffhE=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
