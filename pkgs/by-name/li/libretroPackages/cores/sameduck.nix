{
  lib,
  fetchFromGitHub,
  gitMinimal,
  mkLibretroCore,
  which,
}:
mkLibretroCore {
  core = "sameduck";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "sameduck";
    rev = "f0286ee9d6c44950d9a442463ffdb1ff014a5d5b";
    hash = "sha256-R7nay5yuxTlxbVbI0UYnzpQvPXwMJt+8hCnC90/dkR0=";
  };

  extraNativeBuildInputs = [
    gitMinimal
    which
  ];
  preBuild = "cd libretro";
  makefile = "Makefile";

  meta = {
    description = "Mega Duck emulator core for libretro";
    homepage = "https://github.com/libretro/sameduck";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
