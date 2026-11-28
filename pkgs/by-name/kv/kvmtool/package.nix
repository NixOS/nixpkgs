{
  stdenv,
  fetchgit,
  fetchpatch,
  lib,
  dtc,
}:

let
  withLibfdt = stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isRiscV;
in

stdenv.mkDerivation {
  pname = "kvmtool";
  version = "0-unstable-2026-11-27";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git";
    rev = "4b4aceb1dae7f75c22b53d36a2f021f2a88ebeec";
    hash = "sha256-qdJiQiUiSpxaIUdpfBIyuqQz+5B8+3JVjBp57F6AbXo=";
  };

  patches = [
    # Fixes the build with musl, which has no pthread_attr_setaffinity_np; drop once kvmtool has it
    (fetchpatch {
      name = "set-vcpu-affinity-with-sched-setaffinity.patch";
      url = "https://lore.kernel.org/kvm/20261128061232.64870-1-mikatammi@gmail.com/raw";
      hash = "sha256-ID7BtAms8xFiyJYNKEA5m9VgJSgm2A+PUVemD36FCNQ=";
    })
    # Fixes messages cut off with musl, whose printf rejects %Lu; drop once kvmtool has it
    (fetchpatch {
      name = "use-llu-instead-of-Lu.patch";
      url = "https://lore.kernel.org/kvm/20261128114931.68152-1-mikatammi@gmail.com/raw";
      hash = "sha256-KyFX1gz+n5mDG60KKfUvGjiHRpzRiimxWykLjsd34FA=";
    })
  ];

  buildInputs = lib.optionals withLibfdt [ dtc ];

  # glibc 2.43 C23 const-preserving strchr/strstr macros
  env.NIX_CFLAGS_COMPILE = "-Wno-error=discarded-qualifiers";

  enableParallelBuilding = true;

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ]
  ++ lib.optionals withLibfdt [
    "LIBFDT_DIR=${dtc}/lib"
  ];

  meta = {
    description = "Lightweight tool for hosting KVM guests";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/tree/README";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      astro
      mfrw
      peigongdsd
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "riscv32-linux"
      "riscv64-linux"
    ];
    mainProgram = "lkvm";
  };
}
