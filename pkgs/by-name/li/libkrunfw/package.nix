{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  flex,
  bison,
  bc,
  cpio,
  perl,
  elfutils,
  python3,
  variant ? null,
}:

assert lib.elem variant [
  null
  "sev"
  "tdx"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "libkrunfw" + lib.optionalString (variant != null) "-${variant}";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrunfw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x9HQP+EqCteoCq2Sl/TQcfdzQC5iuE4gaSKe7tN5dAA=";
  };

  kernelSrc = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-6.12.62.tar.xz";
    hash = "sha256-E+LGhayPq13Zkt0QVzJVTa5RSu81DCqMdBjnt062LBM=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'curl $(KERNEL_REMOTE) -o $(KERNEL_TARBALL)' 'ln -s $(kernelSrc) $(KERNEL_TARBALL)'
  '';

  nativeBuildInputs = [
    flex
    bison
    bc
    cpio
    perl
    python3
    python3.pkgs.pyelftools
  ];

  buildInputs = [
    elfutils
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optionals (variant == "sev") [
    "SEV=1"
  ]
  ++ lib.optionals (variant == "tdx") [
    "TDX=1"
  ];

  # Fixes https://github.com/containers/libkrunfw/issues/55
  env = lib.optionalAttrs stdenv.targetPlatform.isAarch64 {
    NIX_CFLAGS_COMPILE = "-march=armv8-a+crypto";
  };

  enableParallelBuilding = true;

  meta = {
    description = "Dynamic library bundling the guest payload consumed by libkrun";
    homepage = "https://github.com/containers/libkrunfw";
    license = with lib.licenses; [
      lgpl2Only
      lgpl21Only
    ];
    maintainers = with lib.maintainers; [
      nickcao
      RossComputerGuy
      nrabulinski
    ];
    platforms = [
      "x86_64-linux"
    ]
    ++ lib.optionals (variant == null) [
      "aarch64-linux"
      "riscv64-linux"
    ];
  };
})
