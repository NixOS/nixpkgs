{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-07-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "63796c5d2d40010b5a495c748b74f5f8cd7d8b4d";
    hash = "sha256-Mv7NSw28O41iPEfaE5d7tAZPgUA7XmRFUODfatgTEiI=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
