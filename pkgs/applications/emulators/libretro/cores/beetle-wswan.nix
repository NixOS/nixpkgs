{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-wswan";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-wswan-libretro";
    rev = "da6d0d9acb8d4e9bd6725ab44225a275325d8352";
    hash = "sha256-ky/8ywP7scg8VXpqwDISw3A0zKwWbh7zAdaLhM91+Rw=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's WonderSwan core to libretro";
    homepage = "https://github.com/libretro/beetle-wswan-libretro";
    license = lib.licenses.gpl2Only;
  };
}
