{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-10-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "135dfa6dfda5e7603d61e751b9ddd0cc42546bc3";
    hash = "sha256-cBowNS0fYJhwcJ0dpNnAYJ9qPt1xLWiGnPgQYpVSPyM=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
