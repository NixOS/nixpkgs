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
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrunfw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mq2gw0+xL6qUZE/fk0vLT3PEpzPV8p+iwRFJHXVOMnk=";
  };

  kernelSrc = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-6.12.34.tar.xz";
    hash = "sha256-p/P+OB9n7KQXLptj77YaFL1/nhJ44DYD0P9ak/Jwwk0=";
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
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.targetPlatform.isAarch64 "-march=armv8-a+crypto";

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
    platforms = [ "x86_64-linux" ] ++ lib.optionals (variant == null) [ "aarch64-linux" ];
  };
})
