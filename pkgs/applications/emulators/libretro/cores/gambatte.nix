{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-10-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "b75225203ffea8b65124bb31acb598e91e7f22d9";
    hash = "sha256-q2gq4eBa1I89PROkxTt7XGIjI2H1eWFDi6lMH+emlmg=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
