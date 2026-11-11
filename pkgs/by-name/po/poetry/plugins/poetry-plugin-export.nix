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
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "poetry-plugin-export";
    tag = version;
    hash = "sha256-/6N/30SK8qdztm7/FrwVqkolVIDxVTt9xxJdC9RcnOg=";
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

  meta = {
    changelog = "https://github.com/python-poetry/poetry-plugin-export/blob/${src.tag}/CHANGELOG.md";
    description = "Poetry plugin to export the dependencies to various formats";
    license = lib.licenses.mit;
    homepage = "https://github.com/python-poetry/poetry-plugin-export";
    maintainers = [ ];
  };
}
