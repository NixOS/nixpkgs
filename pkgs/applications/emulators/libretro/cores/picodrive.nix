{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2025-12-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "3365b1774bc8680be9899968fe45b224ad2f11c1";
    hash = "sha256-hn80Dkdf6dMmCFoh9QeySVbF7tu8Vc1NfAl3SV8AZLg=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
