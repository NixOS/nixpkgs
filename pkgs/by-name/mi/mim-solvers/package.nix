{
  cmake,
  crocoddyl,
  ctestCheckHook,
  fetchFromGitHub,
  lib,
  llvmPackages,
  pkg-config,
  proxsuite,
  python3Packages,
  pythonSupport ? false,
  stdenv,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mim-solvers";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "machines-in-motion";
    repo = "mim_solvers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1Mqu9Hfy65HUIOVG/gJBpSMlOwDWVcH+LrR8CaWz0BE=";
  };

  # eigenpy is not used without python support
  postPatch = lib.optionalString (!pythonSupport) ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "add_project_dependency(eigenpy 2.7.10 REQUIRED)" \
      ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optional pythonSupport python3Packages.pythonImportsCheckHook;
  buildInputs = lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;
  propagatedBuildInputs =
    lib.optionals pythonSupport [
      python3Packages.crocoddyl
      python3Packages.osqp
      python3Packages.proxsuite
      python3Packages.scipy
    ]
    ++ lib.optionals (!pythonSupport) [
      crocoddyl
      proxsuite
    ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_PROXSUITE" true)
  ]
  ++ lib.optional (stdenv.hostPlatform.isDarwin) (
    lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;'py-test-clqr-osqp'"
  )
  ++ lib.optional (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) (
    lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;'test_solvers'"
  );

  nativeCheckInputs = [
    ctestCheckHook
  ];
  disabledTests = [
    # Fails with osqp>=1.0.0
    # See https://github.com/machines-in-motion/mim_solvers/pull/66
    "py-test-clqr-osqp"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Several errors such as:
    # /build/source/tests/test_solvers.cpp(296):
    # error: in "test_SolverCSQP__PointMass1D_X-Ineq-All_U-Eq-All/boost__bind(&test_solver_convergence_ solver_type_ problem_type_ model_type_ x_cstr_type_ u_cstr_type)":
    # check solver_cast->get_norm_dual() <= solver_cast->get_norm_dual_tolerance() has failed
    # Reported upstream: https://github.com/machines-in-motion/mim_solvers/issues/69
    "test_solvers"
  ];
  doCheck = true;

  pythonImportsCheck = [ "mim_solvers" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Numerical solvers used in the Machines in Motion Laboratory";
    homepage = "https://github.com/machines-in-motion/mim_solvers";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
