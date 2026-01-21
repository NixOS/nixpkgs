{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-01-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "473d3072be67fa2542ca833c274ef6682cf0f0bc";
    hash = "sha256-He60RyFhTL7A+juTPbr032tsXoOEOzK4JzCmF03l7gU=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
