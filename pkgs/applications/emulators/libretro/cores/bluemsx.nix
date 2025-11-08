{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bluemsx";
  version = "0-unstable-2025-11-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bluemsx-libretro";
    rev = "1f8aeb9ac3f3a4202736ac22e1785f01a834b975";
    hash = "sha256-VnTL7MLhB/WEHm9930OvM84I5Vp4AaAI6qh7I4QRkVw=";
  };

  meta = {
    description = "Port of BlueMSX to libretro";
    homepage = "https://github.com/libretro/blueMSX-libretro";
    license = lib.licenses.gpl2Only;
  };
}
