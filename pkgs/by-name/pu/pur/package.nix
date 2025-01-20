{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pur";
  version = "7.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alanhamlett";
    repo = "pip-update-requirements";
    tag = version;
    hash = "sha256-zSEzYYpDmu3fennTZNvQjAoMekzxoMDUEqvSjN6hNUk=";
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
