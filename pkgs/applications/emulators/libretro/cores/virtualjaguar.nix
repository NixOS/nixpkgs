{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "virtualjaguar";
  version = "0-unstable-2026-05-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "virtualjaguar-libretro";
    rev = "e04f953915731c15f5f9cb9b8ae44630c901f23f";
    hash = "sha256-jjF3vyVuxViyZP1wbxZduBhURYylGdS3BKxzKnPBm7Q=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of VirtualJaguar to libretro";
    homepage = "https://github.com/libretro/virtualjaguar-libretro";
    license = lib.licenses.gpl3Only;
  };
}
