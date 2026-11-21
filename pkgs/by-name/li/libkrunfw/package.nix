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
  lld,
  llvm,
  variant ? null,
}:

assert lib.elem variant [
  null
  "sev"
  "tdx"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "libkrunfw" + lib.optionalString (variant != null) "-${variant}";
  version = "5.6.2";

  kernelSrc = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-6.12.109.tar.xz";
    hash = "sha256-VITlUqM04VAZ9K66ieW1jwRlHPL04k4E3p8VLxw44/o=";
  };

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "libkrun";
    repo = "libkrunfw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HklZgZPjXe+eAGzRulEwRR1eo83tGlZBTRooCv0/ADU=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'curl $(KERNEL_REMOTE) -o $(KERNEL_TARBALL)' 'ln -s ${finalAttrs.kernelSrc} $(KERNEL_TARBALL)'
  '';

  nativeBuildInputs = [
    flex
    bison
    bc
    cpio
    perl
    python3
    python3.pkgs.pyelftools
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    lld
    llvm
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ elfutils ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optionals (variant == "sev") [
    "SEV=1"
  ]
  ++ lib.optionals (variant == "tdx") [
    "TDX=1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "KERNEL_MAKE=make"
    "MACOS_BUILDER=native"
  ];

  # Causes the build to fail with the error:
  # `unsupported option '-fzero-call-used-regs=used-gpr' for target 'thumbv8a-unknown-linux-gnueabi'`
  hardeningDisable = lib.optionals stdenv.hostPlatform.isDarwin [ "zerocallusedregs" ];

  env = lib.optionalAttrs stdenv.targetPlatform.isAarch64 {
    NIX_CFLAGS_COMPILE =
      # Fixes https://github.com/containers/libkrunfw/issues/55
      "-march=armv8-a+crypto"
      # Fixes build failing on Darwin due to unused `-mmacos-version-min=14.0`
      + lib.optionalString stdenv.hostPlatform.isDarwin " -Wno-error=unused-command-line-argument";
  };

  enableParallelBuilding = true;

  meta = {
    description = "Dynamic library bundling the guest payload consumed by libkrun";
    homepage = "https://github.com/libkrun/libkrunfw";
    license = with lib.licenses; [
      lgpl2Only
      lgpl21Only
    ];
    maintainers = with lib.maintainers; [
      nickcao
      RossComputerGuy
      nrabulinski
      quinneden
    ];
    platforms = [
      "x86_64-linux"
    ]
    ++ lib.optionals (variant == null) [
      "aarch64-darwin"
      "aarch64-linux"
      "riscv64-linux"
    ];
  };
})
