{
  lib,
  llvmPackages,
  callPackage,
  fetchFromGitHub,
  cmake,
  python3,
  z3,
  stp,
  cryptominisat,
  gperftools,
  sqlite,
  gtest,
  lit,
  nix-update-script,

  # Build KLEE in debug mode. Defaults to false.
  debug ? false,

  # Include debug info in the build. Defaults to true.
  includeDebugInfo ? true,

  # Enable KLEE asserts. Defaults to true, since LLVM is built with them.
  asserts ? true,

  # Build the KLEE runtime in debug mode. Defaults to true, as this improves
  # stack traces of the software under test.
  debugRuntime ? true,

  # Enable runtime asserts. Default false.
  runtimeAsserts ? false,

  # Klee uclibc. Defaults to the bundled version.
  kleeuClibc ? null,

  # Extra klee-uclibc config for the default klee-uclibc.
  extraKleeuClibcConfig ? { },
}:

# Klee supports these LLVM versions.
let
  llvmVersion = llvmPackages.llvm.version;
  inherit (lib.strings) versionAtLeast versionOlder;
in
assert versionAtLeast llvmVersion "11" && versionOlder llvmVersion "17";

let
  # The chosen version of klee-uclibc.
  chosenKleeuClibc =
    if kleeuClibc == null then
      callPackage ./klee-uclibc.nix {
        llvmPackages = llvmPackages;
        inherit extraKleeuClibcConfig debugRuntime runtimeAsserts;
      }
    else
      kleeuClibc;

  # Python used for KLEE tests.
  kleePython = python3.withPackages (ps: with ps; [ tabulate ]);
in
llvmPackages.stdenv.mkDerivation rec {
  pname = "klee";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "klee";
    repo = "klee";
    rev = "v${version}";
    hash = "sha256-5js1N8qVF0lCkahSU3ojT7+p/a9IaUpPWhIyFHEzqto=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    llvmPackages.llvm
    cryptominisat
    gperftools
    sqlite
    stp
    z3
  ];

  nativeCheckInputs = [
    gtest

    # Should appear BEFORE lit, since lit passes through python rather
    # than the python environment we make.
    kleePython
    (lit.override { python = kleePython; })
  ];

  cmakeBuildType =
    if debug then
      "Debug"
    else if !debug && includeDebugInfo then
      "RelWithDebInfo"
    else
      "MinSizeRel";

  cmakeFlags =
    let
      onOff = val: if val then "ON" else "OFF";
    in
    [
      "-DKLEE_RUNTIME_BUILD_TYPE=${if debugRuntime then "Debug" else "Release"}"
      "-DLLVMCC=${llvmPackages.clang}/bin/clang"
      "-DLLVMCXX=${llvmPackages.clang}/bin/clang++"
      "-DKLEE_ENABLE_TIMESTAMP=${onOff false}"
      "-DKLEE_UCLIBC_PATH=${chosenKleeuClibc}"
      "-DENABLE_KLEE_ASSERTS=${onOff asserts}"
      "-DENABLE_POSIX_RUNTIME=${onOff true}"
      "-DENABLE_UNIT_TESTS=${onOff true}"
      "-DENABLE_SYSTEM_TESTS=${onOff true}"
      "-DGTEST_SRC_DIR=${gtest.src}"
      "-DGTEST_INCLUDE_DIR=${gtest.src}/googletest/include"
      "-Wno-dev"
    ];

  # Silence various warnings during the compilation of fortified bitcode.
  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-macro-redefined" ];

  prePatch = ''
    patchShebangs --build .
  '';

  # https://github.com/klee/klee/issues/1690
  hardeningDisable = [ "fortify" ];

  enableParallelBuilding = true;
  doCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(\d\.\d)"
      ];
    };
    # Let the user access the chosen uClibc outside the derivation.
    uclibc = chosenKleeuClibc;
  };

  meta = with lib; {
    mainProgram = "klee";
    description = "Symbolic virtual machine built on top of LLVM";
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
    homepage = "https://klee.github.io";
    license = licenses.ncsa;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ numinit ];
  };
}
