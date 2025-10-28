{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bluemsx";
  version = "0-unstable-2025-10-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bluemsx-libretro";
    rev = "3a2855e30c7f39a41064ca36264e9bf9f6170f8e";
    hash = "sha256-k0j15MqmgaTrUc/FoZHuIyALCnMJXeSkx4dfnfrfG5o=";
  };

  meta = {
    description = "Port of BlueMSX to libretro";
    homepage = "https://github.com/libretro/blueMSX-libretro";
    license = lib.licenses.gpl2Only;
  };
}
