{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pur";
  version = "7.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alanhamlett";
    repo = "pip-update-requirements";
    rev = "refs/tags/${version}";
    hash = "sha256-XLI9U9ej3+tS0zzmCDGwZ0pAb3mKnrqBtm90f5N6rMw=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    click
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pur"
  ];

  meta = with lib; {
    description = "Python library for update and track the requirements";
    homepage = "https://github.com/alanhamlett/pip-update-requirements";
    changelog = "https://github.com/alanhamlett/pip-update-requirements/blob/${version}/HISTORY.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pur";
  };
}
