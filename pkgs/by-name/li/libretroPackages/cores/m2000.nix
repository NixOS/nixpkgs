{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "m2000";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "p2000t";
    repo = "M2000";
    rev = "60e12fe9ee07f024b5a0d569ddf6ad8efbffcd4b";
    hash = "sha256-MnqeoQJ/JWdQ7VjuxLVliK65bnWwAc5slqNzr8visTU=";
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
