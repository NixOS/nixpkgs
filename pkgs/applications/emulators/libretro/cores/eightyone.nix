{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "81";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "81-libretro";
    rev = "f9e5fa3bef9a6d6e1e19a4b1c7e5922467b582a2";
    hash = "sha256-c/0L0NLAFyyjQcPNmmfHW29i1As4Wk2/U3qKtClk1VE=";
  };

  meta = {
    description = "Port of EightyOne to libretro";
    homepage = "https://github.com/libretro/81-libretro";
    license = lib.licenses.gpl3Only;
  };
}
