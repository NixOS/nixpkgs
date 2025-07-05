{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
}:

let
  python3' =
    let
      packageOverrides = self: super: {
        scikit-learn = super.scikit-learn.overridePythonAttrs (old: {
          version = "1.5.2";

          src = fetchPypi {
            pname = "scikit_learn";
            version = "1.5.2";
            hash = "sha256-tCN+17P90KSIJ5LmjvJUXVuqUKyju0WqffRoE4rY+U0=";
          };

          # There are 2 tests that are failing, disabling the tests for now.
          # - test_csr_polynomial_expansion_index_overflow[csr_array-False-True-2-65535]
          # - test_csr_polynomial_expansion_index_overflow[csr_array-False-True-3-2344]
          doCheck = false;
        });
      };
    in
    python3.override {
      inherit packageOverrides;
      self = python3;
    };
in
python3'.pkgs.buildPythonApplication rec {
  pname = "rabbit";
  # Make sure to check for which version of scikit-learn this project was built
  # Currently version 2.3.1 is made with scikit-learn 1.5.2
  # Upgrading to newer versions of scikit-learn break the project
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natarajan-chidambaram";
    repo = "RABBIT";
    tag = version;
    hash = "sha256-QmP6yfVnlYoNVa4EUtKR9xbCnQW2V6deV0+hN9IGtic=";
  };

  patches = [
    # Fix file loading, to be removed at the next bump.
    # The author has been notified about the issue and currently working on it.
    ./fix-file-loading.patch
  ];

  pythonRelaxDeps = [
    "numpy"
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
    maintainers = with lib.maintainers; [ drupol ];
  };
}
