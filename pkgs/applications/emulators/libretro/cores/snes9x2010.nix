{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "2f6beca3ada61bdb4dabf7afe8cb9293a699224a";
    hash = "sha256-iM1xR4g3Bhv2XTj+CNA/KY3grjacrPfjpf/jfJkwYbs=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
