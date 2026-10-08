{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mesen-s";
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mesen-s";
    rev = "9e4fdeb9b336470bc96beb8765b2e79c86a2da1e";
    hash = "sha256-caK9Zo/2E7qFsNDEVd+rangnNCM4uA/7s6bQzeGb6D4=";
  };

  makefile = "Makefile";
  preBuild = "cd Libretro";
  normalizeCore = false;

  meta = {
    description = "Port of Mesen-S to libretro";
    homepage = "https://github.com/libretro/mesen-s";
    license = lib.licenses.gpl3Only;
  };
}
