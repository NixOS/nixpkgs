{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-01-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "5b56b6b98ed5f0d7871be4c957fc9d39a608a7c0";
    hash = "sha256-SBVvfrIaXFx984PG4pG1CE0xsTVypOfn/kCvWSgtZSA=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
