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
  asserts ? false,

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
llvmPackages.stdenv.mkDerivation {
  pname = "klee";
  version = "3.1-unstable-2025-07-11";

  src = fetchFromGitHub {
    owner = "klee";
    repo = "klee";
    rev = "1c9fbc1013a6000b39615cc9a5aba83e43a4bf75";
    hash = "sha256-D93T0mBBrIhQTS42ScUHPrMoqCI55Y6Yp7snLmlriQM=";
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
      "-DLIT_ARGS=--verbose"
      "-DGTEST_SRC_DIR=${gtest.src}"
      "-DGTEST_INCLUDE_DIR=${gtest.src}/googletest/include"
      "-Wno-dev"
    ];

  # Silence various warnings during the compilation of fortified bitcode.
  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-macro-redefined" ];

  env.FILECHECK_OPTS = "--dump-input-filter=all";

  env.LIT_XFAIL = lib.concatStringsSep ";" [
    "KLEE :: ArrayOpt/test_expr_arbitrary.c"
    "KLEE :: CXX/SimpleVirtual.cpp"
    "KLEE :: CXX/StaticConstructor.cpp"
    "KLEE :: CXX/StaticDestructor.cpp"
    "KLEE :: Concrete/ConstantExpr.ll"
    "KLEE :: Concrete/OverlappingPhiNodes.ll"
    "KLEE :: Concrete/UnorderedPhiNodes.ll"
    "KLEE :: DeterministicAllocation/nullpage-read.c"
    "KLEE :: DeterministicAllocation/nullpage-write.c"
    "KLEE :: DeterministicAllocation/use-after-free-loh.c"
    "KLEE :: DeterministicAllocation/use-after-free.c"
    "KLEE :: Dogfood/ImmutableSet.cpp"
    "KLEE :: Feature/Atomic.c"
    "KLEE :: Feature/DivCheck.c"
    "KLEE :: Feature/ExtCall.c"
    "KLEE :: Feature/ExtCallWarnings.c"
    "KLEE :: Feature/FunctionAlias.c"
    "KLEE :: Feature/FunctionAliasExit.c"
    "KLEE :: Feature/LargeArrayBecomesSym.c"
    "KLEE :: Feature/LowerSwitch.c"
    "KLEE :: Feature/MakeSymbolicName.c"
    "KLEE :: Feature/NoExternalCallsAllowed.c"
    "KLEE :: Feature/Optimize.c"
    "KLEE :: Feature/OvershiftCheck.c"
    "KLEE :: Feature/ReadStringAtAddress.c"
    "KLEE :: Feature/SeedConcretizeExternalCall.c"
    "KLEE :: Feature/ShiftCheck.c"
    "KLEE :: Feature/consecutive_divide_by_zero.c"
    "KLEE :: Feature/srem.c"
    "KLEE :: InlineAsm/RaiseAsm.c"
    "KLEE :: InlineAsm/asm_lifting.ll"
    "KLEE :: Intrinsics/IntrinsicTrap.ll"
    "KLEE :: Intrinsics/IsConstant.ll"
    "KLEE :: Intrinsics/Missing.ll"
    "KLEE :: Intrinsics/Overflow.ll"
    "KLEE :: Intrinsics/OverflowMul.ll"
    "KLEE :: Intrinsics/Saturating.ll"
    "KLEE :: Intrinsics/noalias-scope-decl.ll"
    "KLEE :: Intrinsics/objectsize.ll"
    "KLEE :: Replay/klee-replay/KleeZesti.c"
    "KLEE :: Replay/libkleeruntest/replay_posix_runtime.c"
    "KLEE :: Runtime/FreeStanding/memcpy_chk_err.c"
    "KLEE :: Runtime/POSIX/CanonicalizeFileName.c"
    "KLEE :: Runtime/POSIX/DirConsistency.c"
    "KLEE :: Runtime/POSIX/DirSeek.c"
    "KLEE :: Runtime/POSIX/Envp.c"
    "KLEE :: Runtime/POSIX/FDNumbers.c"
    "KLEE :: Runtime/POSIX/FD_Fail.c"
    "KLEE :: Runtime/POSIX/FD_Fail2.c"
    "KLEE :: Runtime/POSIX/Fcntl.c"
    "KLEE :: Runtime/POSIX/FilePerm.c"
    "KLEE :: Runtime/POSIX/FreeArgv.c"
    "KLEE :: Runtime/POSIX/Futimesat.c"
    "KLEE :: Runtime/POSIX/Getenv.c"
    "KLEE :: Runtime/POSIX/Ioctl.c"
    "KLEE :: Runtime/POSIX/Isatty.c"
    "KLEE :: Runtime/POSIX/MixedConcreteSymbolic.c"
    "KLEE :: Runtime/POSIX/Openat.c"
    "KLEE :: Runtime/POSIX/PrgName.c"
    "KLEE :: Runtime/POSIX/Read1.c"
    "KLEE :: Runtime/POSIX/Replay.c"
    "KLEE :: Runtime/POSIX/SeedAndFail.c"
    "KLEE :: Runtime/POSIX/Stdin.c"
    "KLEE :: Runtime/POSIX/SymFileConsistency.c"
    "KLEE :: Runtime/POSIX/TestMain.c"
    "KLEE :: Runtime/POSIX/Usage.c"
    "KLEE :: Runtime/POSIX/Write1.c"
    "KLEE :: Runtime/POSIX/Write2.c"
    "KLEE :: Runtime/POSIX/_exit.c"
    "KLEE :: Runtime/Uclibc/2007-10-08-optimization-calls-wrong-libc-functions.c"
    "KLEE :: Runtime/klee-libc/mempcpy.c"
    "KLEE :: Solver/Z3ConstantArray.c"
    "KLEE :: UBSan/ubsan_alignment-type-mismatch.c"
    "KLEE :: UBSan/ubsan_array_bounds.c"
    "KLEE :: UBSan/ubsan_pointer_overflow-pointer_arithmetic.c"
    "KLEE :: UBSan/ubsan_signed_integer_overflow.c"
    "KLEE :: UBSan/ubsan_unsigned_integer_overflow.c"
    "KLEE :: UBSan/ubsan_unsigned_shift_base.c"
    "KLEE :: UBSan/ubsan_vla_bound.c"
    "KLEE :: VarArgs/FunctionAliasVarArg.c"
    "KLEE :: VarArgs/VarArg.c"
    "KLEE :: VarArgs/VarArgAlignment.c"
    "KLEE :: VarArgs/VarArgByVal.c"
    "KLEE :: VarArgs/VarArgByValReported.c"
    "KLEE :: VarArgs/VarArgLongDouble.c"
    "KLEE :: VectorInstructions/floating_point_ops_constant.c"
    "KLEE :: VectorInstructions/integer_ops_constant.c"
    "KLEE :: VectorInstructions/integer_ops_signed_symbolic.c"
    "KLEE :: VectorInstructions/integer_ops_unsigned_symbolic.c"
    "KLEE :: VectorInstructions/memset.c"
    "KLEE :: VectorInstructions/oob-write.c"
    "KLEE :: VectorInstructions/shuffle_element.c"
    "KLEE :: klee-stats/KleeStatsTermClasses.c"
    "KLEE :: regression/2008-03-11-free-of-malloc-zero.c"
    "KLEE :: regression/2014-07-04-unflushed-error-report.c"
    "KLEE :: regression/2016-11-24-bitcast-weak-alias.c"
  ];

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
        "v(\\d\\.\\d)"
      ];
    };
    # Let the user access the chosen uClibc outside the derivation.
    uclibc = chosenKleeuClibc;
  };

  __structuredAttrs = true;

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
    # Upstream is still working on support for LLVM ≥ 16; see:
    #
    # * <https://github.com/klee/klee/pull/1664>
    # * <https://github.com/klee/klee/pull/1745>
    # * <https://github.com/klee/klee/pull/1751>
    # * <https://github.com/klee/klee/issues/1754>
    #
    # The package builds with LLVM 18 but 23% of the tests unexpectedly
    # fail due to missing functionality for newer LLVM versions. We
    # mark them as expected failures above to allow the package to
    # build for those who want to experiment with KLEE, but mark it
    # broken to avoid giving the impression that this is the expected
    # user experience and level of support.
    broken = true;
  };
}
