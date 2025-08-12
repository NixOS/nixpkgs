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
  pkgsCross,
  elfutils,
  python3,
  sevVariant ? false,
  efiVariant ? stdenv.hostPlatform.isDarwin,
  llvmPackages_20,
  llvm,
  linuxHeaders,
  elf-header-real,
}:

let
  elfutils' = if stdenv.hostPlatform.isLinux then elfutils else pkgsCross.aarch64-multiplatform.elfutils;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libkrunfw";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrunfw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wmvjex68Mh7qehA33WNBYHhV9Q/XWLixokuGWnqJ3n0=";
  };

  kernelSrc = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-6.12.20.tar.xz";
    hash = "sha256-Iw6JsHsKuC508H7MG+4xBdyoHQ70qX+QCSnEBySbasc=";
  };

  patches = [
    ./enable-native-build-darwin.patch
  ];

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
    elfutils'
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages_20.lld
    llvm
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optionals sevVariant [
    "SEV=1"
    ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "CC=${lib.getExe llvmPackages_20.clang}"
    "ARCH=arm64"
    "LLVM=1"
  ];

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeFlagsArray+=(HOSTCFLAGS="-D_UUID_T -D__GETHOSTUUID_H -I${elf-header-real}/include -I${linuxHeaders.passthru.darwin-byteswap-h}/include")
    makeFlagsArray+=(CLANG_FLAGS="-fintegrated-as --target=${elfutils'.stdenv.system}")
  '';

  hardeningDisable = lib.optional stdenv.hostPlatform.isAarch64 "zerocallusedregs";

  # Fixes https://github.com/containers/libkrunfw/issues/55
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.targetPlatform.isAarch64 "-march=armv8-a+crypto";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Dynamic library bundling the guest payload consumed by libkrun";
    homepage = "https://github.com/containers/libkrunfw";
    license = with licenses; [
      lgpl2Only
      lgpl21Only
    ];
    maintainers = with maintainers; [
      nickcao
      RossComputerGuy
      nrabulinski
    ];
    platforms = [ "x86_64-linux" ] ++ lib.optionals (!sevVariant) [ "aarch64-linux" ] ++ lib.optionals efiVariant [ "aarch64-darwin" ];
  };
})
