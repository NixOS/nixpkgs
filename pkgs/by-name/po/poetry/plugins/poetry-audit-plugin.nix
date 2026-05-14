{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry,
  safety,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "poetry-audit-plugin";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opeco17";
    repo = "poetry-audit-plugin";
    tag = version;
    hash = "sha256-aAQzgxzBJa/pK+hQj0tN4Zg1MG/sT0rbaMNMIxnhxdU=";
  };

  build-system = [
    poetry-core
  ];

  buildInputs = [
    poetry
  ];

  dependencies = [
    safety
  ];

  pythonImportsCheck = [ "poetry_audit_plugin" ];

  nativeCheckInputs = [
    poetry # for the executable
    pytestCheckHook
  ];

  # requires networking
  doCheck = false;

  meta = {
    changelog = "https://github.com/opeco17/poetry-audit-plugin/releases/tag/${src.tag}";
    description = "Poetry plugin for checking security vulnerabilities in dependencies";
    homepage = "https://github.com/opeco17/poetry-audit-plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
