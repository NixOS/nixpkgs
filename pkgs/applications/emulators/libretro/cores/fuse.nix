{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fuse";
  version = "0-unstable-2024-11-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fuse-libretro";
    rev = "cad85b7b1b864c65734f71aa4a510b6f6536881c";
    hash = "sha256-SdwdcR9szJJoUxQ4y8rh40Bdnn5ZI2qV4OcS39BFViQ=";
  };

  meta = {
    description = "Port of the Fuse Unix Spectrum Emulator to libretro";
    homepage = "https://github.com/libretro/fuse-libretro";
    license = lib.licenses.gpl3Only;
  };
}
