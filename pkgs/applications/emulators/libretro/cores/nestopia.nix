{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2024-12-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "e7b65504ffc7f14fc5c74954d02b18f44c3aaf43";
    hash = "sha256-WI/EPWfTmcPM8SSVroqlya6U5cEgmesSJGbPOjxCSUg=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
