{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x";
  version = "0-unstable-2026-06-16";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = "9df418161bd030d59a0ab0c7b656df68dea11007";
    hash = "sha256-1NZ0ESAunxYOIuk/X+41HELKdxq1U6VG5EG+or+VLkk=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of SNES9x git to libretro";
    homepage = "https://github.com/snes9xgit/snes9x";
    license = lib.licenses.unfreeRedistributable;
  };
}
