{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pce";
  version = "0-unstable-2026-09-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pce-libretro";
    rev = "b96c11e095b6a40a412d2da02766ae1c3f4fd539";
    hash = "sha256-yT1hWeqOcV1O20sn5r9bV6XL9TDePyokt23jymsQ6T0=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PC Engine core to libretro";
    homepage = "https://github.com/libretro/beetle-pce-libretro";
    license = lib.licenses.gpl2Only;
  };
}
