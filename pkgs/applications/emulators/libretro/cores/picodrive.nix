{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2026-07-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "6248b51ffbe212ce441de023ccea6b10fa4d7082";
    hash = "sha256-jiP6/MqLOl5/+CU/cUgKNpXxUtianOkEV1GQHQS+AAw=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
