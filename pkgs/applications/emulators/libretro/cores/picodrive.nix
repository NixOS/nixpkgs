{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2025-05-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "975cdafb613e84e305f87b43e70d1e19df7e60e0";
    hash = "sha256-hRM3DtaTVz35QEkUrPoNXHdS7TgazWIFKU1e+jjfigg=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
