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
  version = "1.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = "poetry-plugin-export";
    tag = version;
    hash = "sha256-RDFx3D7N68E6PnNuJEvqihg7zPeWF6a32x+KyhNUWds=";
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
