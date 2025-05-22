{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2025-04-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "c4332d608c1005a46ce51236ade9894e0d32e52b";
    hash = "sha256-qu5pnqHHO/k8OO2XXwd/H7AQsutmnMz+RBT6ZZFXZgk=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
