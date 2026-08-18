{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-wswan";
  version = "0-unstable-2026-07-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-wswan-libretro";
    rev = "4b01295838ea89e3f1355bbe4cb5cf98aa6108cd";
    hash = "sha256-vCkh6duAEK/Am5oy1SYybE75gcc3idpd3Uvjt09a9uA=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's WonderSwan core to libretro";
    homepage = "https://github.com/libretro/beetle-wswan-libretro";
    license = lib.licenses.gpl2Only;
  };
}
