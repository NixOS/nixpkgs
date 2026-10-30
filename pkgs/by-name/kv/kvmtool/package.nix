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
  version = "0-unstable-2026-08-06";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git";
    rev = "f67bc0bdae9433a9cfd05e65ea2c1bb6102566d9";
    hash = "sha256-eVE3lM0Xsv11T9IQ694639rLqvjjaee1Ob60vq3Ho3g=";
  };

  patches = [
    # Fixes the feature checks, which all failed as stdenv sets make's SHELL; drop once kvmtool has it
    (fetchpatch {
      name = "fix-feature-checks-with-shell-set.patch";
      url = "https://lore.kernel.org/kvm/20261030004422.33732-1-mikatammi@gmail.com/raw";
      hash = "sha256-46yK/TzPGvZFggvV3DEJ9CEPK5qgsD06yoUzoL+Zr0w=";
    })
    # Fixes FDT_ERR_ALIGNMENT on riscv32; drop once kvmtool has it
    (fetchpatch {
      name = "align-fdt-staging-buffer.patch";
      url = "https://lore.kernel.org/kvm/20261028190531.48302-1-mikatammi@gmail.com/raw";
      hash = "sha256-RO1Ael0mkxIMA4F2pGKkzhhMz3Bq9faL+VSII03S26Q=";
    })
    # Fixes cross builds for x86_64, which ran the build platform's nm; drop once kvmtool has it
    (fetchpatch {
      name = "x86-cross-nm.patch";
      url = "https://lore.kernel.org/kvm/20261030104018.71809-1-mikatammi@gmail.com/raw";
      hash = "sha256-uWSmpbKJ0pmh8kVsFcd06c+j2tppn0+RjP9TVbPHi0E=";
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
