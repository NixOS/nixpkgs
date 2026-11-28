{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mame2010";
  version = "0-unstable-2026-11-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2010-libretro";
    rev = "16a9093cf0fded4895c035e7fb01e88f38eaf08d";
    hash = "sha256-HDTTdvKx1nYDQ93UUcnebTfX8VB1xWDKBpcQ4KTt4fA=";
  };

  patches = [
    # Fix the build: the libretro-common update renamed path_default_slash()
    # to PATH_DEFAULT_SLASH(), but retromain.c still used the old name
    # https://github.com/libretro/mame2010-libretro/pull/176
    ./mame2010-path-default-slash.patch
  ];

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
