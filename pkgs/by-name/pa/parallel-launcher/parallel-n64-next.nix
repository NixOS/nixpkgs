{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  libGLU,
  libGL,
  libpng,
  libretro,
}:
let
  # Converts a version string like x.y.z to vx.y-z
  reformatVersion = v: "v${lib.versions.majorMinor v}-${lib.versions.patch v}";
in
# Based on the libretro parallel-n64 derivation with slight tweaks
libretro.mkLibretroCore (finalAttrs: {
  core = "parallel-n64-next";
  version = "2.27.1";

  src = fetchFromGitLab {
    owner = "parallel-launcher";
    repo = "parallel-n64";
    tag = reformatVersion finalAttrs.version;
    hash = "sha256-u4F6CbC1NEU3OWtcqMIi/teX+SS4Jq9v5M2qc9z5bXg=";
  };

  extraNativeBuildInputs = [
    pkg-config
  ];

  extraBuildInputs = [
    libGLU
    libGL
    libpng
  ];

  makefile = "Makefile";

  makeFlags = [
    "HAVE_PARALLEL=1"
    "HAVE_PARALLEL_RSP=1"
    "HAVE_THR_AL=1"
    "SYSTEM_LIBPNG=1"
    "SYSTEM_ZLIB=1"
    "ARCH=${stdenv.hostPlatform.parsed.cpu.name}"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    sed -i -e '1 i\CPUFLAGS += -DARM_FIX -DNO_ASM -DARM_ASM -DDONT_WANT_ARM_OPTIMIZATIONS -DARM64' Makefile \
    && sed -i -e 's,CPUFLAGS  :=,,g' Makefile
  '';

  preInstall =
    let
      suffix = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mv parallel_n64_libretro${suffix} parallel_n64_next_libretro${suffix}
    '';

  passthru.updateScript = { };

  meta = {
    description = "Fork of libretro's parallel-n64 core designed to be used with Parallel Launcher";
    homepage = "https://gitlab.com/parallel-launcher/parallel-n64";
    license = lib.licenses.gpl3Only;
    teams = [ ];
    maintainers = with lib.maintainers; [
      WheelsForReals
    ];
    badPlatforms = [
      "aarch64-linux"
    ];
  };
})
