{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-supergrafx";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-supergrafx-libretro";
    rev = "3442f442b112ccf869791600661438804f1dfc51";
    hash = "sha256-5MJ9IxIL2PX0vxZTSCcAHjxacK5BQZ+Dj5tSxiW+2x8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's SuperGrafx core to libretro";
    homepage = "https://github.com/libretro/beetle-supergrafx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
