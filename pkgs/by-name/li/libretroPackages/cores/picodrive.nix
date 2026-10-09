{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2026-09-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "ab021146b70eef7ec0ac2afe06a94e9b4c16ef74";
    hash = "sha256-Iza5jKZjLfnqcbbDw9vYLRfl7/++0SoQKBQ15cBYiIo=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
