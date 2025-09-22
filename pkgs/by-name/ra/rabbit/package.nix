{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
}:

let
  python3' = python3.override {
    packageOverrides = self: super: {
      scikit-learn =
        let
          version = "1.5.2";
        in
        super.scikit-learn.overridePythonAttrs (old: {
          inherit version;

          src = fetchPypi {
            pname = "scikit_learn";
            inherit version;
            hash = "sha256-tCN+17P90KSIJ5LmjvJUXVuqUKyju0WqffRoE4rY+U0=";
          };

          # There are 2 tests that are failing, disabling the tests for now.
          # - test_csr_polynomial_expansion_index_overflow[csr_array-False-True-2-65535]
          # - test_csr_polynomial_expansion_index_overflow[csr_array-False-True-3-2344]
          doCheck = false;
        });
    };
    self = python3;
  };

  # Make sure to check for which version of scikit-learn this project was built
  # Currently version 2.3.2 is made with scikit-learn 1.5.2
  # Upgrading to newer versions of scikit-learn break the project
  version = "2.3.2";
in
python3'.pkgs.buildPythonApplication {
  pname = "rabbit";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natarajan-chidambaram";
    repo = "RABBIT";
    tag = version;
    hash = "sha256-icf42vqYPNH1v1wEv/MpqScqMUr/qDlcGoW9kPY2R6s=";
  };

  pythonRelaxDeps = [
    "joblib"
    "numpy"
    "requests"
    "scikit-learn"
    "scipy"
    "tqdm"
    "urllib3"
  ];

  build-system = with python3'.pkgs; [
    setuptools
  ];

  dependencies = with python3'.pkgs; [
    joblib
    numpy
    pandas
    python-dateutil
    requests
    scikit-learn
    scipy
    tqdm
    urllib3
  ];

  pythonImportsCheck = [ "rabbit" ];

  meta = {
    description = "Tool for identifying bot accounts based on their recent GitHub event history";
    homepage = "https://github.com/natarajan-chidambaram/RABBIT";
    license = lib.licenses.asl20;
    mainProgram = "rabbit";
    maintainers = with lib.maintainers; [ ];
  };
}
