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
  sevVariant ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkrunfw";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrunfw";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-GFfBiGMOyBwMKjpD1kj3vRpvjR0ydji3QNDyoOQoQsw=";
  };

  kernelSrc = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-6.6.59.tar.xz";
    hash = "sha256-I2FoCNjAjxKBX/iY9O20wROXorKEPQKe5iRS0hgzp20=";
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

  makeFlags =
    [
      "PREFIX=${placeholder "out"}"
    ]
    ++ lib.optionals sevVariant [
      "SEV=1"
    ];

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
    ];
    platforms = [ "x86_64-linux" ] ++ lib.optionals (!sevVariant) [ "aarch64-linux" ];
  };
})
