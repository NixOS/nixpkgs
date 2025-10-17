{
  cmake,
  crocoddyl,
  ctestCheckHook,
  fetchFromGitHub,
  fetchpatch,
  lib,
  llvmPackages,
  pkg-config,
  proxsuite,
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

  patches = [
    # ref. https://github.com/machines-in-motion/mim_solvers/pull/71 merged upstream
    (fetchpatch {
      name = "build-standalone-python-interface.patch";
      url = "https://github.com/machines-in-motion/mim_solvers/commit/796eecf05dd9165dd0795aa562ead17de4f19633.patch";
      hash = "sha256-/OiMzyDVEbpC/Dr/HcguwAdhmbQNxnIRsHAVkX68xqA=";
    })
    # Fix for crocoddyl 3.1.0
    # ref. https://github.com/machines-in-motion/mim_solvers/pull/72
    ./fix-croco-310.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  propagatedBuildInputs = [
    crocoddyl
    proxsuite
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_WITH_PROXSUITE" true)
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];
  disabledTests = [
    # Fails with osqp>=1.0.0
    # See https://github.com/machines-in-motion/mim_solvers/pull/67
    "py-test-clqr-osqp"
    # need removed ActuationModelMultiCopterBase in crocoddyl 3.1.0
    "py-test-sqp-no-reg"
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Numerical solvers used in the Machines in Motion Laboratory";
    homepage = "https://github.com/machines-in-motion/mim_solvers";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
