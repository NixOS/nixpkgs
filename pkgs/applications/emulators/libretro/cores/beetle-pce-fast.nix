{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pce-fast";
  version = "0-unstable-2025-03-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pce-fast-libretro";
    rev = "9f2b7943db1fb784daf0948b0b493bc7f76919f8";
    hash = "sha256-fwrfZ0Z/DAtDRuBqxCS11/qNoomAtUgEOf4eOLk9vO0=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PC Engine fast core to libretro";
    homepage = "https://github.com/libretro/beetle-pce-fast-libretro";
    license = lib.licenses.gpl2Only;
  };
}
