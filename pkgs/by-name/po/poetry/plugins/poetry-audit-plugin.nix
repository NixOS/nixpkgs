{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  poetry,
  safety,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "poetry-audit-plugin";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "opeco17";
    repo = "poetry-audit-plugin";
    rev = "refs/tags/${version}";
    hash = "sha256-kiNtzEup2ygCTk0zk8YV2jxAj6ZzOhP8v0U4FbV15hI=";
  };

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "poetry"
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
    description = "Poetry plugin for checking security vulnerabilities in dependencies";
    homepage = "https://github.com/opeco17/poetry-audit-plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
