{ lib
, callPackage
, fetchFromGitHub
, fetchpatch
, cmake
, llvmPackages_9
, clang_9
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
    inherit clang_9 llvmPackages_9 extraKleeuClibcConfig debugRuntime runtimeAsserts;
  };
in
clang_9.stdenv.mkDerivation rec {
  pname = "klee";
  version = "2.2";
  src = fetchFromGitHub {
    owner = "klee";
    repo = "klee";
    rev = "v${version}";
    sha256 = "Ar3BKfADjJvvP0dI9+x/l3RDs8ncx4jmO7ol4MgOr4M=";
  };
  buildInputs = [
    llvmPackages_9.llvm
    z3 stp cryptominisat
    gperftools sqlite
  ];
  nativeBuildInputs = [
    cmake clang_9
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

  patches = map fetchpatch [
    /* This patch is currently necessary for the unit test suite to run correctly.
     * See https://www.mail-archive.com/klee-dev@imperial.ac.uk/msg03136.html
     * and https://github.com/klee/klee/pull/1458 for more information.
     */
    {
      name = "fix-gtest";
      sha256 = "F+/6videwJZz4sDF9lnV4B8lMx6W11KFJ0Q8t1qUDf4=";
      url = "https://github.com/klee/klee/pull/1458.patch";
    }

    # This patch fixes test compile issues with glibc 2.33+.
    {
      name = "fix-glibc-2.33";
      sha256 = "PzxqtFyLy9KF1eA9AAKg1tu+ggRdvu7leuvXifayIcc=";
      url = "https://github.com/klee/klee/pull/1385.patch";
    }

    # /etc/mtab doesn't exist in the Nix build sandbox.
    {
      name = "fix-etc-mtab-in-tests";
      sha256 = "2Yb/rJA791esNNqq8uAXV+MML4YXIjPKkHBOufvyRoQ=";
      url = "https://github.com/klee/klee/pull/1471.patch";
    }
  ];

  doCheck = true;
  checkTarget = "check";

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
