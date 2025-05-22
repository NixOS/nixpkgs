{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-05-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "fad7beb42c90a1a04829d465bed951a69cd36f8b";
    hash = "sha256-pO45/IvgT2q5k0sBhSNZ6srJx4h2lYSjG/mKFJesGbc=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
