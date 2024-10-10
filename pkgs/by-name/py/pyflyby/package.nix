{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pyflyby";
  version = "1.8.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deshaw";
    repo = "pyflyby";
    rev = version;
    hash = "sha256-4zDgxq1mSyixnmkSeUXbJMMdg5qhDwZUvcxoOB4jeEI=";
  };
  disabled = python3.pythonOlder "3.7";

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    six
    toml
    isort
    black
    ipython
  ];

  pythonImportsCheck = [ "pyflyby" ];

  meta = with lib; {
    description = "A set of productivity tools for Python";
    homepage = "https://github.com/deshaw/pyflyby";
    license = licenses.mit;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "py";
  };
}
