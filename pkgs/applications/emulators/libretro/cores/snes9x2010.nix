{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-04-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "a7a4bfaed4c6408908c76af20ad625e1645c3d11";
    hash = "sha256-mtTgh/koM7jS7/cH7qRgTa+xJXBBJSdxHHbhOd/q4i4=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
