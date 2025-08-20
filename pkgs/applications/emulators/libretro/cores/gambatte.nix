{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "36a0da43fe6a82aba6acc5336574dbd749b18fa8";
    hash = "sha256-3PM7PK1ouMObNZEIIIBG8gxIydYFKP9RRGlWBr5PIGU=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
