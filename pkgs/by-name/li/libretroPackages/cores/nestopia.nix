{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-10-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "06a8949e0b3cf60e3a38a374b1426bf40fccb9a0";
    hash = "sha256-vh7voFaYu1KVCDKIiUEMKTc1aVmD6XVU/YvkWQKknsk=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
