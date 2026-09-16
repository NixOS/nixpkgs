{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fmsx";
  version = "0-unstable-2026-09-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fmsx-libretro";
    rev = "ee14f0df43765e399ca018ad2c2b3eaaf96785e7";
    hash = "sha256-EKGFUo+AmS2sho9FDWD5Pxa/SWeBVrAK/5jqWsMfSrk=";
  };

  makefile = "Makefile";

  meta = {
    description = "FMSX libretro port";
    homepage = "https://github.com/libretro/fmsx-libretro";
    license = lib.licenses.unfreeRedistributable;
  };
}
