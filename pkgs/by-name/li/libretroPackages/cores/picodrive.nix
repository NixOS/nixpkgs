{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2026-08-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "733c711a477a642fd2006d5a7a581b2790ec36b4";
    hash = "sha256-fD3NHgPjbEpKNZQNJX4N6PYS+9pR405Szu/sqDDP+9s=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
