{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-07-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "8b0d82d9a515b6c75bd46fd80c3e2e19b0780998";
    hash = "sha256-wbfIbb5Bb78gb1N2L5g/Z3YzqzE3+0tVYVS/vyjtTzQ=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
