{
  lib,
  stdenv,
  fetchFromGitHub,
  libGL,
  libGLU,
  libpng,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "parallel-n64";
  version = "0-unstable-2025-03-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "parallel-n64";
    rev = "f8605345e13c018a30c8f4ed03c05d8fc8f70be8";
    hash = "sha256-6yb/vrcp0pQpNzngDHhcWC1U4ghtSZ0BVoT5NXd8Gwo=";
  };

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
    badPlatforms = [
      # ./mupen64plus-core/src/r4300/new_dynarec/arm64/linkage_aarch64.o: in function `.E12':
      # (.text+0x5b4): relocation truncated to fit: R_AARCH64_CONDBR19 against symbol `invalidate_block' defined in .text section in ./mupen64plus-core/src/r4300/new_dynarec/new_dynarec_64.o
      # collect2: error: ld returned 1 exit status
      "aarch64-linux"
    ];
  };
}
