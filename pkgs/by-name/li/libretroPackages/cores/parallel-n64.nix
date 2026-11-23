{
  lib,
  stdenv,
  fetchFromGitHub,
  libGL,
  libGLU,
  libpng,
  mkLibretroCore,
  nasm,
}:
mkLibretroCore {
  core = "parallel-n64";
  version = "0-unstable-2026-11-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "parallel-n64";
    rev = "31858dac789ea86069dbdba8f09d2d08c05d0d39";
    hash = "sha256-3PXZSi82mVZfQSgj9mvd1FlSK0hJe223JNwUt+W4Hac=";
  };

  extraNativeBuildInputs = lib.optionals stdenv.hostPlatform.isx86 [ nasm ];

  extraBuildInputs = [
    libGLU
    libGL
    libpng
  ];
  makefile = "Makefile";
  makeFlags = [
    "HAVE_PARALLEL=1"
    "HAVE_PARALLEL_RSP=1"
    "ARCH=${stdenv.hostPlatform.parsed.cpu.name}"
  ];
  postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    sed -i -e '1 i\CPUFLAGS += -DARM_FIX -DNO_ASM -DARM_ASM -DDONT_WANT_ARM_OPTIMIZATIONS -DARM64' Makefile \
    && sed -i -e 's,CPUFLAGS  :=,,g' Makefile
  '';

  meta = {
    description = "Parallel Mupen64plus rewrite for libretro";
    homepage = "https://github.com/libretro/parallel-n64";
    license = lib.licenses.gpl3Only;
  };
}
