{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  withBlarggAPU ? false,
}:
mkLibretroCore {
  core = "snes9x2005" + lib.optionalString withBlarggAPU "-plus";
  version = "0-unstable-2026-09-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2005";
    rev = "a79dfe9047e7fec58808aefe48ad2bf499c7af11";
    hash = "sha256-AMpb2uErW9Kf87rJs1+0/9gs8WMa7w90kcxqsOh1RQc=";
  };

  makefile = "Makefile";
  makeFlags = lib.optionals withBlarggAPU [ "USE_BLARGG_APU=1" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.43 to Libretro";
    homepage = "https://github.com/libretro/snes9x2005";
    license = lib.licenses.unfreeRedistributable;
  };
}
