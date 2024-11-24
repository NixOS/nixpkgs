{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2024-11-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "f9ae8fd28b13070a945a829ccf41cbf90a21d0f7";
    hash = "sha256-nsExAYnzDenPvXzeN60jGykRTrCGMi/mRPV+vgS8ZtE=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
