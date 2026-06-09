{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-06-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "6716e6ee39c2abd3ea325f66fb26e7f866f4c5dc";
    hash = "sha256-sn8UWO1YR3qLpsR0dwpyy42L+QWrYpwO2lL4NqgUmWM=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
