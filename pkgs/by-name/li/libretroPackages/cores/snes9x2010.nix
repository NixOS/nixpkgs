{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-09-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "fe690dd321fa5a46b5234a2bde089d2518c62b0e";
    hash = "sha256-OdGb5tZ5bfcncruGKFBdEgbp44qGeXTI2qIEsq5H9Ck=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
