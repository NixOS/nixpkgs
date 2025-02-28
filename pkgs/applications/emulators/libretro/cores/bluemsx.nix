{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bluemsx";
  version = "0-unstable-2024-12-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bluemsx-libretro";
    rev = "572c91856a5288b7433c619af651e31f00f3ce7e";
    hash = "sha256-fN5zjQGIyx3yIEgIhC50gD3O2F6WPJ/ssiauQ5Z/t9s=";
  };

  meta = {
    description = "Port of BlueMSX to libretro";
    homepage = "https://github.com/libretro/blueMSX-libretro";
    license = lib.licenses.gpl2Only;
  };
}
