{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2024-12-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "6bbfff9a56ead67f0da696ab2c3aea3c11896964";
    hash = "sha256-D2FtfabikcZq0dl+ot/NJJkOaQXj0Sl5P2ioNrvxgSs=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
