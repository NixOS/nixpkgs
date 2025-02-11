{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry,
  poetry-core,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "poetry-plugin-export";
  version = "1.9.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    tag = version;
    hash = "sha256-AP3/njzbLEi2s4pOUSLLLzqNprvxwLe9LSY7qh08EWc=";
  };

  build-system = [
    poetry-core
  ];

  buildInputs = [
    poetry
  ];

  nativeCheckInputs = [
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/python-poetry/poetry-plugin-export/blob/${src.rev}/CHANGELOG.md";
    description = "Poetry plugin to export the dependencies to various formats";
    license = licenses.mit;
    homepage = "https://github.com/python-poetry/poetry-plugin-export";
    maintainers = [ ];
  };
}
