{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "e9429844f2e16a284a8cdf663589634fd4c6345f";
    hash = "sha256-Ss4AuIuwEbaQOUcnGfXbJbEw/1HkyGZSRD2ody+wSSU=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
