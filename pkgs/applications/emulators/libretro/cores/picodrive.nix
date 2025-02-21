{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2025-02-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "6123398dfe16ada8048f5ee5255e1a9e726edbf5";
    hash = "sha256-rgFmdZBtWpVClfcVMBa7tSGb98z5ejCln/w4GrFu4VA=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
