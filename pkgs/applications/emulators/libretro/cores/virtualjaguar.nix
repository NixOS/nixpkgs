{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "virtualjaguar";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "virtualjaguar-libretro";
    rev = "48096c1f6f8b98cfff048a5cb4e6a86686631072";
    hash = "sha256-DLBQQARHqupGGQS8YznDSSMuxQliyt5apGA4Ku2jlYo=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of VirtualJaguar to libretro";
    homepage = "https://github.com/libretro/virtualjaguar-libretro";
    license = lib.licenses.gpl3Only;
  };
}
