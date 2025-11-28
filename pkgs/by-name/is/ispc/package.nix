{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  which,
  m4,
  python3,
  bison,
  flex,
  llvmPackages,
  ncurses,
  onetbb,
  # the default test target is sse4, but that is not supported by all Hydra agents
  testedTargets ?
    if stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isAarch32 then
      [ "neon-i32x4" ]
    else
      [ "sse2-i32x4" ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ispc";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "ispc";
    repo = "ispc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dmpOvJ5dVhjGKpJ9xw/lXbvk2FgLv2vjzmUExUfLRmo=";
  };

  nativeBuildInputs = [
    cmake
    which
    m4
    bison
    flex
    python3
    llvmPackages.libllvm.dev
    onetbb
  ];

  buildInputs = with llvmPackages; [
    libllvm
    libclang
    openmp
    ncurses
  ];

  postPatch =
    # Workaround for LLVM version mismatch: the build uses libcxx 19 (from darwin
    # stdenv), while LLVM 21 is provided as a runtime dependency.
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace src/util.cpp \
        --replace-fail "#ifdef _LIBCPP_VERSION" "#if FALSE"
    ''
    # These tests fail on x86_64-darwin, see ispc/ispc#{3529, 3623}
    + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
      substituteInPlace tests/func-tests/round-float16-uniform.ispc \
        --replace-fail "// See issue #3529" "// rule: skip on OS=mac"

      substituteInPlace tests/func-tests/round-float16-varying.ispc \
        --replace-fail "// See issue #3529" "// rule: skip on OS=mac"
    '';

  inherit testedTargets;

  doCheck = true;

  # the compiler enforces -Werror, and -fno-strict-overflow makes it mad.
  # hilariously this is something of a double negative: 'disable' the
  # 'strictoverflow' hardening protection actually means we *allow* the compiler
  # to do strict overflow optimization. somewhat misleading...
  hardeningDisable = [ "strictoverflow" ];

  checkPhase = ''
    export ISPC_HOME=$PWD/bin
    for target in $testedTargets
    do
      echo "Testing target $target"
      echo "================================"
      echo
      (cd ../
       PATH=${llvmPackages.clang}/bin:$PATH python scripts/run_tests.py -t $target --non-interactive --verbose --file=test_output.log
       fgrep -q "No new fails"  test_output.log || exit 1)
    done
  '';

  cmakeFlags = [
    (lib.cmakeFeature "FILE_CHECK_EXECUTABLE" "${llvmPackages.llvm}/bin/FileCheck")
    (lib.cmakeFeature "LLVM_AS_EXECUTABLE" "${llvmPackages.llvm}/bin/llvm-as")
    (lib.cmakeFeature "LLVM_CONFIG_EXECUTABLE" "${llvmPackages.llvm.dev}/bin/llvm-config")
    (lib.cmakeFeature "CLANG_EXECUTABLE" "${llvmPackages.clang}/bin/clang")
    (lib.cmakeFeature "CLANGPP_EXECUTABLE" "${llvmPackages.clang}/bin/clang++")
    (lib.cmakeBool "ISPC_INCLUDE_EXAMPLES" false)
    (lib.cmakeBool "ISPC_INCLUDE_UTILS" false)
    (lib.cmakeFeature "ARM_ENABLED=" (
      if stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isAarch32 then "TRUE" else "FALSE"
    ))
    (lib.cmakeFeature "X86_ENABLED=" (
      if stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isx86_32 then "TRUE" else "FALSE"
    ))
  ];

  meta = {
    description = "Intel 'Single Program, Multiple Data' Compiler, a vectorised language";
    homepage = "https://ispc.github.io/";
    changelog = "https://github.com/ispc/ispc/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      thoughtpolice
      athas
      alexfmpe
    ];
    mainProgram = "ispc";
    platforms = with lib.platforms; linux ++ darwin; # TODO: buildable on more platforms?
  };
})
