{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-03-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "4b3edb41d33e52b6d70c4e18bf0819a070991b66";
    hash = "sha256-8RmNDvUd64FqEgduNMHgbunu92SqMi+Pn//Ou2EQUFs=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
