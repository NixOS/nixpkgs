{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "m2000";
  version = "0-unstable-2026-10-31";

  src = fetchFromGitHub {
    owner = "p2000t";
    repo = "M2000";
    rev = "dd0e04b12526e79ffd4dec27ba8969f36a627e9d";
    hash = "sha256-bbkNbrWMspKQQrO6P3irpeD42MgjwZ9EED/88rilHYs=";
  };

  sourceRoot = "source/src/libretro";
  makefile = "Makefile";

  meta = {
    description = "Philips P2000T emulator core for libretro";
    homepage = "https://github.com/p2000t/M2000";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
