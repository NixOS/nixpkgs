{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-06-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "780e4259f096797931a3030d08ffaeec62f2a593";
    hash = "sha256-l7+WCiY7Pf0/5GzsmHT/C67uNF8JEzblDlr7oKiYcgA=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
