{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2010";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2010-libretro";
    rev = "cc63285e2109263da4eca0911ba07aec60b8109b";
    hash = "sha256-vyOJNOnk74pvsfPq0Kg9ovQ/bS8R2ByA8SVMqixaueQ=";
  };

  makefile = "Makefile";
  makeFlags = lib.optionals stdenv.hostPlatform.isAarch64 [
    "PTR64=1"
    "ARM_ENABLED=1"
    "X86_SH2DRC=0"
    "FORCE_DRC_C_BACKEND=1"
  ];

  meta = {
    description = "Port of MAME ~2010 to libretro, compatible with MAME 0.139 sets";
    homepage = "https://github.com/libretro/mame2010-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
