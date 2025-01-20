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
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "parallel-n64";
    rev = "e372c5e327dcd649e9d840ffc3d88480b6866eda";
    hash = "sha256-q4octB5XDdl4PtLYVZfBgydVBNaOwzu9dPBY+Y68lVo=";
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
  };
}
