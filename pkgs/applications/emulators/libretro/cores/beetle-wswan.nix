{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-wswan";
  version = "0-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-wswan-libretro";
    rev = "440e9228592a3f603d7d09e8bee707b0163f545f";
    hash = "sha256-+98gCDBYeqUlFGzX83lwTGqSezLnzWRwapZCn4T37uE=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's WonderSwan core to libretro";
    homepage = "https://github.com/libretro/beetle-wswan-libretro";
    license = lib.licenses.gpl2Only;
  };
}
