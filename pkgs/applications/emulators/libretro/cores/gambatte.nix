{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-07-25";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "13b7af780e9893ae62cc24d567591b5eb6a6dd72";
    hash = "sha256-bTNZrXp+kMIq/tnPs73tpYRxlrZfCGCmE0EUlJFtUnY=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
