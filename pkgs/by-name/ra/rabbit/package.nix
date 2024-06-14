{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rabbit";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natarajan-chidambaram";
    repo = "RABBIT";
    rev = "refs/tags/${version}";
    hash = "sha256-5ItoWjPpAbQFM6+B+1CvZe5r5rZXQ8pWj7gRIKGX8ZA=";
  };

  pythonRelaxDeps = true;

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    numpy
    pandas
    pip
    requests
    scikit-learn
    scipy
    tqdm
    xgboost
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
