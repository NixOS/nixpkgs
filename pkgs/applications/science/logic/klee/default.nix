{ lib
, callPackage
, fetchFromGitHub
, cmake
, llvmPackages_11
, clang
, python3
, zlib
, z3
, stp
, cryptominisat
, gperftools
, sqlite
, gtest
, lit

# Build KLEE in debug mode. Defaults to false.
, debug ? false

# Include debug info in the build. Defaults to true.
, includeDebugInfo ? true

# Enable KLEE asserts. Defaults to true, since LLVM is built with them.
, asserts ? true

# Build the KLEE runtime in debug mode. Defaults to true, as this improves
# stack traces of the software under test.
, debugRuntime ? true

# Enable runtime asserts. Default false.
, runtimeAsserts ? false

# Extra klee-uclibc config.
, extraKleeuClibcConfig ? {}
}:

let

  # Python used for KLEE tests.
  kleePython = python3.withPackages (ps: with ps; [ tabulate ]);

  # The klee-uclibc derivation.
  kleeuClibc = callPackage ./klee-uclibc.nix {
    inherit clang llvmPackages_11 extraKleeuClibcConfig debugRuntime runtimeAsserts;
  };

in
clang.stdenv.mkDerivation rec {

  pname = "klee";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "klee";
    repo = "klee";
    rev = "v${version}";
    sha256 = "sha256-E1c6K6Q+LAWm342W8I00JI6+LMvqmULHZLkv9Kj5RmY=";
  };

  buildInputs = [
    cryptominisat
    gperftools
    lit # Configure phase checking for lit
    llvmPackages_11.llvm
    sqlite
    stp
    z3
  ];

  nativeBuildInputs = [
    clang
    cmake
  ];

  checkInputs = [
    gtest

    # Should appear BEFORE lit, since lit passes through python rather
    # than the python environment we make.
    kleePython
    (lit.override { python3 = kleePython; })
  ];

  cmakeFlags = let
    onOff = val: if val then "ON" else "OFF";
  in [
    "-DCMAKE_BUILD_TYPE=${if debug then "Debug" else if !debug && includeDebugInfo then "RelWithDebInfo" else "MinSizeRel"}"
    "-DKLEE_RUNTIME_BUILD_TYPE=${if debugRuntime then "Debug" else "Release"}"
    "-DKLEE_ENABLE_TIMESTAMP=${onOff false}"
    "-DENABLE_KLEE_UCLIBC=${onOff true}"
    "-DKLEE_UCLIBC_PATH=${kleeuClibc}"
    "-DENABLE_KLEE_ASSERTS=${onOff asserts}"
    "-DENABLE_POSIX_RUNTIME=${onOff true}"
    "-DENABLE_UNIT_TESTS=${onOff true}"
    "-DENABLE_SYSTEM_TESTS=${onOff true}"
    "-DGTEST_SRC_DIR=${gtest.src}"
    "-DGTEST_INCLUDE_DIR=${gtest.src}/googletest/include"
    "-Wno-dev"
  ];

  # Silence various warnings during the compilation of fortified bitcode.
  NIX_CFLAGS_COMPILE = ["-Wno-macro-redefined"];

  prePatch = ''
    patchShebangs .
  '';

  doCheck = true;

  passthru = {
    # Let the user depend on `klee.uclibc` for klee-uclibc
    uclibc = kleeuClibc;
  };

  meta = with lib; {
    description = "A symbolic virtual machine built on top of LLVM";
    longDescription = ''
      KLEE is a symbolic virtual machine built on top of the LLVM compiler
      infrastructure. Currently, there are two primary components:

      1. The core symbolic virtual machine engine; this is responsible for
         executing LLVM bitcode modules with support for symbolic values. This
         is comprised of the code in lib/.

      2. A POSIX/Linux emulation layer oriented towards supporting uClibc, with
         additional support for making parts of the operating system environment
         symbolic.

      Additionally, there is a simple library for replaying computed inputs on
      native code (for closed programs). There is also a more complicated
      infrastructure for replaying the inputs generated for the POSIX/Linux
      emulation layer, which handles running native programs in an environment
      that matches a computed test input, including setting up files, pipes,
      environment variables, and passing command line arguments.
    '';
    homepage = "https://klee.github.io/";
    license = licenses.ncsa;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ numinit ];
  };
}
