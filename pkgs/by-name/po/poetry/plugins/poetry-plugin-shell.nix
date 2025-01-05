{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pexpect,
  poetry,
  poetry-core,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  shellingham,
}:

buildPythonPackage rec {
  pname = "poetry-plugin-shell";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "poetry-plugin-shell";
    tag = version;
    hash = "sha256-ynbZCzic6bAIwtG0rGk4oMPc8pm59UFboNAGUb0qJnE=";
  };

  build-system = [ poetry-core ];

  buildInputs = [
    poetry
  ];

  dependencies = [
    pexpect
    shellingham
  ];

  nativeCheckInputs = [
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/python-poetry/poetry-plugin-shell/blob/${src.tag}/CHANGELOG.md";
    description = "Poetry plugin to run subshell with virtual environment activated";
    homepage = "https://github.com/python-poetry/poetry-plugin-shell";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
