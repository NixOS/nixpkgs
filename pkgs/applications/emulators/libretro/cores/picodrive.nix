{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2025-03-25";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "752c266491ae8775dab9a98dbd94472f42b9b16f";
    hash = "sha256-l9qYOUyQzyleWeQv74rEOEwOk6iyH43WVIUHcC6Aw2Y=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
