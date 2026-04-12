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
  backend ? "mcode",
}:

assert backend == "mcode" || backend == "llvm" || backend == "gcc";

stdenv.mkDerivation (finalAttrs: {
  pname = "ghdl-${backend}";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "ghdl";
    repo = "ghdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q5lAWMa1SFjoIJTdWlHSbS4Cg5RYWiej8F05Xrz9ArY=";
  };

  env.LIBRARY_PATH = "${stdenv.cc.libc}/lib";

  nativeBuildInputs = [
    gnat
  ]
  ++ lib.optionals (backend == "gcc") [
    texinfo
    makeWrapper
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optionals (backend == "llvm") [
    llvm
  ]
  ++ lib.optionals (backend == "gcc") [
    gmp
    mpfr
    libmpc
  ];

  propagatedBuildInputs = [
  ]
  ++ lib.optionals (backend == "llvm" || backend == "gcc") [
    zlib
  ];

  preConfigure = ''
    # If llvm 7.0 works, 7.x releases should work too.
    sed -i 's/check_version  7.0/check_version  7/g' configure
  ''
  + lib.optionalString (backend == "gcc") ''
    ${gnutar}/bin/tar -xf ${gcc13.cc.src}
  '';

  configureFlags = [
    # See https://github.com/ghdl/ghdl/pull/2058
    "--disable-werror"
    "--enable-synth"
  ]
  ++ lib.optionals (backend == "llvm") [
    "--with-llvm-config=${llvm.dev}/bin/llvm-config"
  ]
  ++ lib.optionals (backend == "gcc") [
    "--with-gcc=gcc-${gcc13.cc.version}"
  ];

  buildPhase = lib.optionalString (backend == "gcc") ''
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
      --with-mpc=${libmpc}
    make -j $NIX_BUILD_CORES
    make install
    cd ../
    make -j $NIX_BUILD_CORES ghdllib
  '';

  postFixup = lib.optionalString (backend == "gcc") ''
    wrapProgram $out/bin/ghdl \
      --set LIBRARY_PATH ${
        lib.makeLibraryPath [
          stdenv.cc.libc
        ]
      }
  '';

  hardeningDisable = [
  ]
  ++ lib.optionals (backend == "gcc") [
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
    platforms =
      lib.platforms.linux ++ lib.optionals (backend == "mcode" || backend == "llvm") [ "x86_64-darwin" ];
  };
})
