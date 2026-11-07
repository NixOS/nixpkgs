{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cython,
  joblib,
  lapack,
  nilearn,
  numpy,
  scikit-learn,
  scipy,
  seaborn,
  tabulate,

  # tests
  pytestCheckHook,

  # passthru
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "skggm";
  # Last official release was made in 2018, but there are several dependency
  # bumps and compat fixes in development since then which makes this easier
  # to package:
  version = "0.2.8-unstable-2025-06-14";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "skggm";
    repo = "skggm";
    rev = "6792fe7d0079bb7c62e701921e37782a209234cb";
    hash = "sha256-+9XxvmcWo4GMv4n+/NV/3J+pQbMkktEoy5U1c19DsEg=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail \
        "description-file = README.md" \
        "description_file = README.md"
  ''
  # Don't try to build with SSE2 instructions on Aarch64:
  + lib.optionalString stdenv.hostPlatform.isAarch64 ''
    substituteInPlace setup.py \
      --replace-fail "'-msse2', " ""
  '';

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "numpy"
    "tabulate"
  ];
  pythonRemoveDeps = [
    "nose"
  ];
  dependencies = [
    cython
    joblib
    lapack
    nilearn
    numpy
    scikit-learn
    scipy
    seaborn
    tabulate
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Test against the _installed_ package, not the sources in the current workdir.
  preCheck = ''
    rm -f inverse_covariance/__init__.py
    rm -f inverse_covariance/profiling/__init__.py
  '';

  # Disable tests that depend on outdated dependencies
  disabledTestPaths = [
    # Imports assert_raises/assert_allclose from sklearn.utils._testing (private module removed in
    # scikit-learn 1.3); fails at collection time
    "inverse_covariance/tests/quic_graph_lasso_test.py"

    # QuicGraphicalLassoCV/AdaptiveGraphicalLasso use sklearn.utils.as_float_array (removed in
    # scikit-learn 1.2); fails at import time
    "inverse_covariance/tests/adaptive_graph_lasso_test.py"

    # Calls check_estimator on all skggm estimators; they fail because
    # QuicGraphicalLasso/ModelAverage use sklearn.utils.as_float_array (removed in scikit-learn 1.2)
    "inverse_covariance/tests/common_test.py"

    # ModelAverage imports sklearn.utils.as_float_array (removed in scikit-learn 1.2); fails at
    # import time
    "inverse_covariance/tests/model_average_test.py"

    # MonteCarloProfile's default estimator is QuicGraphicalLasso, which uses
    # sklearn.utils.as_float_array (removed in scikit-learn 1.2); fails at runtime
    "inverse_covariance/profiling/tests/monte_carlo_profile_test.py"
  ];

  disabledTests = [
    # Uses numpy.in1d which was removed in numpy 2.0
    "test_has_approx_support"
  ];

  pythonImportsCheck = [ "inverse_covariance" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Gaussian graphical models using the scikit-learn API";
    homepage = "https://github.com/skggm/skggm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
