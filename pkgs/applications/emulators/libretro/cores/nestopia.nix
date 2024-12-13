{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2024-12-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "8b622a6e2a7403fff47830e0437f324ed9f24464";
    hash = "sha256-I9YKOV+mPZrcA5bB1KfWk+NaWIxSpBpZT8ntNxSt/m0=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
