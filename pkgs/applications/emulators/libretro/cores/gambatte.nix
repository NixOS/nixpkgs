{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "ac3d17d07a1119df5eb124494dfa90e47ae2e5ff";
    hash = "sha256-5240slUbHUYb6Xp65xPvvCopdciyGK+Z8mdk7i0ALIQ=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
