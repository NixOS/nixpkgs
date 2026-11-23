{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-11-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "2cfc5f304fe8b1db65e464efaa50fa46f273c472";
    hash = "sha256-Pcf1t/eLZHNm0+onuIzLh85TAfYkNpacloDV0AoUYjY=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
