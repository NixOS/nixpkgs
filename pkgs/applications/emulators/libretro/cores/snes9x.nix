{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x";
  version = "0-unstable-2026-08-17";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = "2971061cf07fdc6fc7d18883edf4e648eb16a6d2";
    hash = "sha256-OX//MXLRWRWNhl5YOoL6VyzPxBu4pVkUz7BWXscuNXM=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of SNES9x git to libretro";
    homepage = "https://github.com/snes9xgit/snes9x";
    license = lib.licenses.unfreeRedistributable;
  };
}
