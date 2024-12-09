{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "2048";
  version = "0-unstable-2024-06-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-2048";
    rev = "5474ed1ab880b3296c9860d0943d7de1970c79dd";
    hash = "sha256-i6bbxsLpSicDDGYKAxTMCMioHHfvBzVokun3PNYgDsc=";
  };

  meta = {
    description = "Port of 2048 puzzle game to libretro";
    homepage = "https://github.com/libretro/libretro-2048";
    license = lib.licenses.unlicense;
  };
}
