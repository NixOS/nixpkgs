{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
  testers,
  rabbit,
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

          postPatch = ''
            substituteInPlace pyproject.toml \
              --replace-fail "numpy>=2" "numpy" 

            substituteInPlace meson.build --replace-fail \
              "run_command('sklearn/_build_utils/version.py', check: true).stdout().strip()," \
              "'${version}',"
          '';
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pandas==2.2.3" "pandas" 
  '';

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

  passthru.tests.version = testers.testVersion {
    package = rabbit;
    command = "rabbit --help";
    version = "RABBIT is an Activity Based Bot Identification Tool";
  };

  meta = {
    description = "Tool for identifying bot accounts based on their recent GitHub event history";
    homepage = "https://github.com/natarajan-chidambaram/RABBIT";
    license = lib.licenses.asl20;
    mainProgram = "rabbit";
    maintainers = [ ];
  };
}
