{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jaxtyping,
  linear-operator,
  mpmath,
  scikit-learn,
  scipy,
  setuptools,
  setuptools-scm,
  torch,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gpytorch";
  version = "1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-whZjqAs3nyjKMzAGi+OnyBtboq0UuV8m11A4IzkWtec=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "jaxtyping" ];

  dependencies = [
    jaxtyping
    linear-operator
    mpmath
    scikit-learn
    scipy
    torch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gpytorch" ];

  disabledTests = [
    # AssertionError on number of warnings emitted
    "test_deprecated_methods"
    # flaky numerical tests
    "test_classification_error"
    "test_matmul_matrix_broadcast"
    "test_optimization_optimal_error"
    # https://github.com/cornellius-gp/gpytorch/issues/2396
    "test_t_matmul_matrix"
  ];

  meta = with lib; {
    description = "Highly efficient and modular implementation of Gaussian Processes, with GPU acceleration";
    homepage = "https://gpytorch.ai";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
