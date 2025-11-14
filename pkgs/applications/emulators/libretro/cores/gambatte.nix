{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-11-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "45ee875b71de88502f8c0a7fe497e3dc708c1fee";
    hash = "sha256-E6rrPE/cu8xhM0dOY/MnWpYrqG/NKtmmbas9ieBle/8=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
