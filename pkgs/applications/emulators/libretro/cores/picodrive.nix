{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2025-04-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "1a08d73159820bb31941d8c5ed6242a74bd4b332";
    hash = "sha256-849XeceXoPHpOMlxVtHgL2TYQTHibUbGs0oHBEiCzvw=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
