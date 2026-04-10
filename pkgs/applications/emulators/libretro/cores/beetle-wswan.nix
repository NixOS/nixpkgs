{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-wswan";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-wswan-libretro";
    rev = "392db084316475411f3f24bd1ea54dba72ecbe51";
    hash = "sha256-GbjE2PqfZGrP9tp4TgyIzdyyC1PatGiQRSscsmcIbPQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's WonderSwan core to libretro";
    homepage = "https://github.com/libretro/beetle-wswan-libretro";
    license = lib.licenses.gpl2Only;
  };
}
