{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-08-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "51ad831fcd9f10a02dcb0cbf398c2cd1b028765e";
    hash = "sha256-4TMJfD9KUBo5qJNOdnSEq2oEftL8Fpak6tHOP+tuG2U=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
