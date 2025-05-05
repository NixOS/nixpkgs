{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pylint-plugin-utils,
  pytestCheckHook,
  setuptools,
}:
buildPythonPackage rec {
  pname = "pylint-odoo";
  version = "9.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OCA";
    repo = "pylint-odoo";
    tag = "v${version}";
    hash = "sha256-HPai1HQlfHJUHLqEYn4U6qdupJLLrynwtfm7Q8IbRps=";
  };

  pythonRelaxDeps = [
    "pylint-plugin-utils"
    "pylint"
  ];

  build-system = [ setuptools ];

  dependencies = [
    pylint-plugin-utils
  ];

  pythonImportsCheck = [ "pylint_odoo" ];

  BUILD_README = true; # Enables more tests

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Odoo plugin for Pylint";
    homepage = "https://github.com/OCA/pylint-odoo";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
