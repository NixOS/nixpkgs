{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-05-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "0b95f252ba9cdb366b4d87e6236b0a63f4305cba";
    hash = "sha256-EcTd5ihZcdQ2LJNy8jcD4g6+PhR1Jialjd3xa6tZMew=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
