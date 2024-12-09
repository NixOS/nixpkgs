{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bluemsx";
  version = "0-unstable-2024-10-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bluemsx-libretro";
    rev = "01ce142ccb85c302420cb962d1b6e6a68a6ce076";
    hash = "sha256-h3Zpv+h6CbM1pdSOXsjN0pFUjXLn5T/R5W55VZXpMVM=";
  };

  meta = {
    description = "Port of BlueMSX to libretro";
    homepage = "https://github.com/libretro/blueMSX-libretro";
    license = lib.licenses.gpl2Only;
  };
}
