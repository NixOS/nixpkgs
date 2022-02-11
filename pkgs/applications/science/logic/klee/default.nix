{ stdenv
, lib
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
, debug ? false
}:

let
  kleePython = python3.withPackages (ps: with ps; [ tabulate ]);
in
stdenv.mkDerivation rec {
  pname = "klee";
  version = "2.2";
  src = fetchFromGitHub {
    owner = "klee";
    repo = "klee";
    rev = "v${version}";
    sha256 = "Ar3BKfADjJvvP0dI9+x/l3RDs8ncx4jmO7ol4MgOr4M=";
  };
  buildInputs = [
    llvmPackages_9.llvm clang_9 z3 stp cryptominisat
    gperftools sqlite
  ];
  nativeBuildInputs = [
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
    buildType = if debug then "Debug" else "Release";
  in
  [
    "-DCMAKE_BUILD_TYPE=${buildType}"
    "-DKLEE_RUNTIME_BUILD_TYPE=${buildType}"
    "-DENABLE_POSIX_RUNTIME=ON"
    "-DENABLE_UNIT_TESTS=ON"
    "-DENABLE_SYSTEM_TESTS=ON"
    "-DGTEST_SRC_DIR=${gtest.src}"
    "-DGTEST_INCLUDE_DIR=${gtest.src}/googletest/include"
    "-Wno-dev"
  ];

  # Silence various warnings during the compilation of fortified bitcode.
  NIX_CFLAGS_COMPILE = ["-Wno-macro-redefined"];

  prePatch = ''
    patchShebangs .
  '';

  /* This patch is currently necessary for the unit test suite to run correctly.
   * See https://www.mail-archive.com/klee-dev@imperial.ac.uk/msg03136.html
   * and https://github.com/klee/klee/pull/1458 for more information.
   */
  patches = map fetchpatch [
    {
      name = "fix-gtest";
      sha256 = "F+/6videwJZz4sDF9lnV4B8lMx6W11KFJ0Q8t1qUDf4=";
      url = "https://github.com/klee/klee/pull/1458.patch";
    }
  ];

  doCheck = true;
  checkTarget = "check";

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
