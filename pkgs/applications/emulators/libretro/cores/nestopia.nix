{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "d2eefab298b0b9152d2934d6f0227b6803c877b3";
    hash = "sha256-lmfyNi+E2SoCOAtXuJ3F5S3mm1OCta9FHtoqPpLgYk8=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
