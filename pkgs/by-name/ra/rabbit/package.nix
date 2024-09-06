{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rabbit";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natarajan-chidambaram";
    repo = "RABBIT";
    rev = "refs/tags/${version}";
    hash = "sha256-diy94QhgLHLvkb1kKhGDxiHAyQ43BNJUXjHFYahEDpw=";
  };

  pythonRelaxDeps = [
    "numpy"
    "scikit-learn"
    "scipy"
    "tqdm"
  ];

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
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
