{
  stdenv,
  fetchgit,
  lib,
  dtc,
}:

let
  withLibfdt = stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isRiscV64;
in

stdenv.mkDerivation {
  pname = "kvmtool";
  version = "0-unstable-2026-08-06";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git";
    rev = "f67bc0bdae9433a9cfd05e65ea2c1bb6102566d9";
    hash = "sha256-eVE3lM0Xsv11T9IQ694639rLqvjjaee1Ob60vq3Ho3g=";
  };

  patches = [ ./strlcpy-glibc-2.38-fix.patch ];

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
      "riscv64-linux"
    ];
    mainProgram = "lkvm";
  };
}
