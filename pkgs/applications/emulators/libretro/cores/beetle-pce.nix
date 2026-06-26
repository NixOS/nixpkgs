{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pce";
  version = "0-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pce-libretro";
    rev = "ae99235c2139c176c1a8d0fde2957bf701d3cab0";
    hash = "sha256-3bxKLWivTpCmAPYqu5r7AuwvREXRCndq6JQ4hgd18YU=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PC Engine core to libretro";
    homepage = "https://github.com/libretro/beetle-pce-libretro";
    license = lib.licenses.gpl2Only;
  };
}
