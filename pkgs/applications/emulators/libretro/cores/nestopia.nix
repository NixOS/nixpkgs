{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-01-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "9762adc00668f3a2e1016f3ad07ff9cbf9d67459";
    hash = "sha256-CLEwhQ91dxoTLyhlQwssoCL/dEqY6SetwWLogfJi8RU=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
