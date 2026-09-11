{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2010";
  version = "0-unstable-2026-09-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2010-libretro";
    rev = "dff8aadd1c3f38215af3955746d6e19abe0ddcea";
    hash = "sha256-UfppTEDAnUkV8RzAlbsZIRjYy6Jj2GMWOp3T3lsix68=";
  };

  makefile = "Makefile";
  makeFlags = lib.optionals stdenv.hostPlatform.isAarch64 [
    "PTR64=1"
    "ARM_ENABLED=1"
    "X86_SH2DRC=0"
    "FORCE_DRC_C_BACKEND=1"
  ];

  # MAME zeroes memory before placement new (auto_alloc_clear and friends)
  # to initialize objects, which GCC otherwise optimizes away, leaving e.g.
  # input port settings uninitialized so that games fail validity checks
  env.NIX_CFLAGS_COMPILE = "-fno-lifetime-dse";

  meta = {
    description = "Port of MAME ~2010 to libretro, compatible with MAME 0.139 sets";
    homepage = "https://github.com/libretro/mame2010-libretro";
    # MAME license, non-commercial clause
    license = lib.licenses.unfreeRedistributable;
  };
}
