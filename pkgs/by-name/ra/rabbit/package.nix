{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rabbit";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natarajan-chidambaram";
    repo = "RABBIT";
    rev = "refs/tags/${version}";
    hash = "sha256-ykvI5qW4toNYKAnrk3ADwat1gAUazbDGGKZEZAvKngQ=";
  };

  pythonRelaxDeps = true;

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    python3.pkgs.pythonRelaxDepsHook
  ];

  dependencies = with python3.pkgs; [
    numpy
    pandas
    pip
    python-dateutil
    requests
    scikit-learn
    scipy
    tqdm
    urllib3
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
