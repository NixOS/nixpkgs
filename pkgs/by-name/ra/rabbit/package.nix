{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rabbit";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natarajan-chidambaram";
    repo = "RABBIT";
    rev = version;
    hash = "sha256-IRG3OcWutkZA4oegeEIDyaIadl3dLaMneqOt/H2/Il4=";
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
    requests
    scikit-learn
    scipy
    tqdm
    xgboost
  ];

  pythonImportsCheck = [ "rabbit" ];

  meta = {
    description = "A tool for identifying bot accounts based on their recent GitHub event history";
    homepage = "https://github.com/natarajan-chidambaram/RABBIT";
    license = lib.licenses.asl20;
    mainProgram = "rabbit";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
