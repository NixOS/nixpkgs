{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-09-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "38fe97c000ac3f2ea92e929dc24c25fcec0bc567";
    hash = "sha256-9Iu5v9Vd7iiqeBhE4VM57tslgU0Ldk80hB08uLV3D0U=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
