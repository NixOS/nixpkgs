{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-wswan";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-wswan-libretro";
    rev = "2aeb47d3a58bf0360c686f842d9bb5bd201306fe";
    hash = "sha256-LrF9p5tPtUamVLC41bJxcYDKvHmhVfwMieyIAdHaGmU=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's WonderSwan core to libretro";
    homepage = "https://github.com/libretro/beetle-wswan-libretro";
    license = lib.licenses.gpl2Only;
  };
}
