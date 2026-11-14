{
  lib,
  fetchFromGitHub,
  gitMinimal,
  mkLibretroCore,
  which,
}:
mkLibretroCore {
  core = "sameduck";
  version = "0-unstable-2026-09-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "sameduck";
    rev = "040e19c379f00dae10afe0eb0c1b2b019b985bbe";
    hash = "sha256-bt89cRhdDl3JLbTiQGKKUJXGnq0P+KZIQddmMMqiiSw=";
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
