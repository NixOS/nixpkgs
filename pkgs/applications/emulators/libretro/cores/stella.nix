{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-01-26";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "2da2e050d261f0f2df40eec3ca64f73e05bde5f6";
    hash = "sha256-CZrgahSdU6Ri0Cq/Z0iS3jjEfsW/TS1reuMzUb9yGNM=";
  };

  makefile = "Makefile";
  preBuild = "cd src/os/libretro";
  dontConfigure = true;

  meta = {
    description = "Port of Stella to libretro";
    homepage = "https://github.com/stella-emu/stella";
    license = lib.licenses.gpl2Only;
  };
}
