{
  stdenv,
  fetchFromGitHub,
  callPackage,
  gnat,
  zlib,
  llvm,
  lib,
  gcc13,
  texinfo,
  gmp,
  mpfr,
  libmpc,
  gnutar,
  makeWrapper,
  backend ? if stdenv.hostPlatform.isAarch64 then "llvm-jit" else "mcode",
}:

assert lib.asserts.assertOneOf "backend" backend [
  "mcode"
  "llvm"
  "llvm-jit"
  "gcc"
];

let
  backendIsLLVM = backend == "llvm";
  backendIsLLVMJit = backend == "llvm-jit";
  backendIsGCC = backend == "gcc";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ghdl-${backend}";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "ghdl";
    repo = "ghdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q5lAWMa1SFjoIJTdWlHSbS4Cg5RYWiej8F05Xrz9ArY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  env.LIBRARY_PATH = "${stdenv.cc.libc}/lib";

  nativeBuildInputs = [
    gnat
  ]
  ++ lib.optionals (backendIsLLVM || backendIsGCC) [
    makeWrapper
  ]
  ++ lib.optionals backendIsGCC [
    texinfo
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optionals backendIsGCC [
    gmp
    mpfr
    libmpc
  ];

  preConfigure = ''
    # If llvm 7.0 works, 7.x releases should work too.
    sed -i 's/check_version  7.0/check_version  7/g' configure
  ''
  + lib.optionalString backendIsGCC ''
    ${gnutar}/bin/tar -xf ${gcc13.cc.src}
  '';

  configureFlags = [
    # See https://github.com/ghdl/ghdl/pull/2058
    "--disable-werror"
    "--enable-synth"
  ]
  ++ lib.optionals (backendIsLLVM || backendIsLLVMJit) [
    "--with-llvm-config=${llvm.dev}/bin/llvm-config"
  ]
  ++ lib.optionals backendIsLLVMJit [
    "--with-llvm-jit"
  ]
  ++ lib.optionals backendIsGCC [
    "--with-gcc=gcc-${gcc13.cc.version}"
  ];

  buildPhase = lib.optionalString backendIsGCC ''
    make copy-sources
    mkdir gcc-objs
    cd gcc-objs
    ../gcc-${gcc13.cc.version}/configure \
      --with-native-system-header-dir=${lib.getDev stdenv.cc.libc}/include \
      --with-build-sysroot=/ \
      --prefix=$out \
      --enable-languages=c,vhdl \
      --disable-bootstrap \
      --disable-lto \
      --disable-multilib \
      --disable-libssp \
      --disable-libgomp \
      --disable-libquadmath \
      --with-gmp-include=${gmp.dev}/include \
      --with-gmp-lib=${gmp.out}/lib \
      --with-mpfr-include=${mpfr.dev}/include \
      --with-mpfr-lib=${mpfr.out}/lib \
      --with-mpc=${libmpc} \
      --enable-default-pie=${lib.boolToYesNo stdenv.targetPlatform.hasSharedLibraries}
    make -j $NIX_BUILD_CORES
    make install
    cd ../
    make -j $NIX_BUILD_CORES ghdllib
  '';

  postFixup = lib.optionalString (backendIsLLVM || backendIsGCC) ''
    wrapProgram $out/bin/ghdl \
      --set LIBRARY_PATH ${lib.makeLibraryPath [ zlib ]} \
      --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
  '';

  hardeningDisable = [
  ]
  ++ lib.optionals backendIsGCC [
    # GCC compilation fails with format errors
    "format"
  ];

  enableParallelBuilding = true;

  passthru = {
    # run with:
    # nix-build -A ghdl-mcode.passthru.tests
    # nix-build -A ghdl-llvm.passthru.tests
    # nix-build -A ghdl-gcc.passthru.tests
    tests = {
      simple = callPackage ./test-simple.nix { inherit backend; };
    };
  };

  meta = {
    homepage = "https://github.com/ghdl/ghdl";
    description = "VHDL 2008/93/87 simulator";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ghdl";
    maintainers = with lib.maintainers; [
      lucus16
      thoughtpolice
      sempiternal-aurora
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ]
    ++ lib.optionals (backendIsLLVM || backendIsLLVMJit || backendIsGCC) [ "aarch64-linux" ]
    ++ lib.optionals (backendIsLLVM || backendIsLLVMJit) [ "aarch64-darwin" ];
  };
})
