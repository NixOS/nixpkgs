{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-02-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "72003d06eb9fbc2191f5a7a874abc039bde3157f";
    hash = "sha256-fo9ZNqgMDt9s/18WDhD+7kGb9O8LF47Xk5yuIP3trqY=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
