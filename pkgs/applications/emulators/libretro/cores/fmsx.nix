{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fmsx";
  version = "0-unstable-2026-06-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fmsx-libretro";
    rev = "f013e213458e06d9df718e4bc4b09d46f88aa899";
    hash = "sha256-+SItMLIY2tgFdXm2wtJdbPaKWhNJH41Mh9329Ln2Pyk=";
  };

  makefile = "Makefile";

  meta = {
    description = "FMSX libretro port";
    homepage = "https://github.com/libretro/fmsx-libretro";
    license = lib.licenses.unfreeRedistributable;
  };
}
