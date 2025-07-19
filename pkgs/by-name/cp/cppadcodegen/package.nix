{
  adolc,
  cmake,
  cppad,
  doxygen,
  eigen,
  fetchFromGitHub,
  graphviz,
  gtest,
  lib,
  llvmPackages,
  makeFontsConf,
  pkg-config,
  stdenv,
  texlive,
  valgrind,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppadcodegen";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "joaoleal";
    repo = "CppADCodeGen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-na8o+bqzign2nSk5AQdkIVQm3CIb0oFqEneGnYKQDyg=";
  };

  patches = [
    # Use gtest from nixpkgs instead of downloading it from github
    # ref https://github.com/joaoleal/CppADCodeGen/pull/90
    ./90_cmake-look-for-system-gtest.patch
  ];

  outputs = [
    "doc"
    "out"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
    texlive.combined.scheme-basic
  ];
  propagatedBuildInputs = [
    cppad
    eigen
  ];
  buildInputs = [
    adolc
    llvmPackages.clang
    llvmPackages.libclang
    llvmPackages.llvm
  ];
  checkInputs = [
    gtest
  ] ++ lib.optional stdenv.hostPlatform.isLinux valgrind;

  cmakeFlags =
    let
      failingTests = lib.concatStringsSep "|" [
        # never ending
        "dynamiclib_pthreadpool_memcheck"

        # failed / aborted / segfault
        "abs"
        "abs_memcheck"
        "acos"
        "acos_memcheck"
        "acosh"
        "acosh_memcheck"
        "add"
        "add_memcheck"
        "asin"
        "asin_memcheck"
        "asinh"
        "asinh_memcheck"
        "assign"
        "assign_memcheck"
        "atan"
        "atan_memcheck"
        "atan_2"
        "atan_2_memcheck"
        "atanh"
        "atanh_memcheck"
        "cond_exp"
        "cond_exp_memcheck"
        "cos"
        "cos_memcheck"
        "cosh"
        "cosh_memcheck"
        "div_memcheck"
        "erf"
        "erf_memcheck"
        "erfc_memcheck"
        "exp_memcheck"
        "expm1_memcheck"
        "log"
        "log_memcheck"
        "log1p"
        "log1p_memcheck"
        "log_10"
        "log_10_memcheck"
        "mul"
        "mul_memcheck"
        "parameter"
        "parameter_memcheck"
        "pow"
        "pow_memcheck"
        "sin"
        "sin_memcheck"
        "sub"
        "sub_memcheck"
        "tan"
        "tan_memcheck"
        "unary"
        "unary_memcheck"
        "cstr"
        "cstr_memcheck"
        "cstr_2"
        "cstr_2_memcheck"
        "dynamic_atomic_cstr"
        "dynamic_atomic_cstr_memcheck"
        "dynamic_atomic_cstr_nested"
        "dynamic_atomic_cstr_nested_memcheck"
        "dynamic"
        "dynamic_memcheck"
        "cg_atomic_generic_model"
        "cg_atomic_generic_model_memcheck"
        "dynamic_atomic"
        "dynamic_atomic_memcheck"
        "dynamic_atomic_2"
        "dynamic_atomic_2_memcheck"
        "dynamic_atomic_3"
        "dynamic_atomic_3_memcheck"
        "dynamic_cond_exp"
        "dynamic_forward_reverse"
        "dynamic_forward_reverse_memcheck"
        "dynamic_forward_reverse_2_memcheck"
        "latex"
        "latex_memcheck"
        "pattern_matcher"
        "pattern_matcher_memcheck"
        "missing_equation"
        "missing_equation_memcheck"
        "cross_iteration"
        "cross_iteration_memcheck"
        "hessian_with_loops"
        "hessian_with_loops_memcheck"
        "simple_atomic"
        "simple_atomic_memcheck"
        "simple_atomic_2"
        "simple_atomic_2_memcheck"
        "simple_atomic_deploop"
        "simple_atomic_deploop_memcheck"
        "plug_flow"
        "plug_flow_memcheck"
        "cstr_collocation"
        "tank_battery"
        "tank_battery_memcheck"
        "div"
        "exp"
        "expm1"
      ];
    in
    [
      (lib.cmakeBool "CREATE_DOXYGEN_DOC" true)
      (lib.cmakeBool "ENABLE_TEST_CPPCHECKS" true)
      (lib.cmakeFeature "CMAKE_BUILD_TYPE" "RelWithDebInfo")
      (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;'${failingTests}'")
    ];

  # Fontconfig error: No writable cache directories
  preBuild = "export XDG_CACHE_HOME=$(mktemp -d)";

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  preCheck = "cmake --build . -t build_tests";

  doCheck = true;

  meta = {
    description = "Source Code Generation for Automatic Differentiation using Operator Overloading";
    homepage = "https://github.com/joaoleal/CppADCodeGen";
    license = with lib.licenses; [
      epl10
      gpl3Only
    ];
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
