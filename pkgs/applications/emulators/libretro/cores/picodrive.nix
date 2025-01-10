{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2024-12-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "bb4b7bcddb9f2f218e88971cccc66edf6c7669f0";
    hash = "sha256-KbPsPG4pFZRHQoLuPVvBdXQTa+uXtmvSBKi7ShMyB3A=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
