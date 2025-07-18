{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-06-26";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "c6ce6e80e87c828701629980e8a7119f3b08c5ab";
    hash = "sha256-403Z0W9OQYbb8+O8kSWbpHkqywVhXbqqIyfsGlgEi+M=";
  };

  makefile = "Makefile";
  preBuild = "cd src/os/libretro";
  dontConfigure = true;

  meta = {
    description = "Port of Stella to libretro";
    homepage = "https://github.com/stella-emu/stella";
    license = lib.licenses.gpl2Only;
  };
}
