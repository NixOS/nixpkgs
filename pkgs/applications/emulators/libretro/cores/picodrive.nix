{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2025-10-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "5b8cdea5cb06fb8d3d8ce7b88695f8dd00b4ac12";
    hash = "sha256-Xnw1ZYo+w5ubU4VMEP1IbCNLvBgpopUWVepcIUF7MH4=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
