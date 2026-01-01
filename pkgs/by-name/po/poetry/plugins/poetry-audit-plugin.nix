{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  poetry-core,
  poetry,
  safety,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "poetry-audit-plugin";
<<<<<<< HEAD
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opeco17";
    repo = "poetry-audit-plugin";
    tag = version;
    hash = "sha256-aAQzgxzBJa/pK+hQj0tN4Zg1MG/sT0rbaMNMIxnhxdU=";
=======
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "opeco17";
    repo = "poetry-audit-plugin";
    rev = "refs/tags/${version}";
    hash = "sha256-kiNtzEup2ygCTk0zk8YV2jxAj6ZzOhP8v0U4FbV15hI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    poetry-core
  ];

<<<<<<< HEAD
=======
  pythonRelaxDeps = [
    "poetry"
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    changelog = "https://github.com/opeco17/poetry-audit-plugin/releases/tag/${src.tag}";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Poetry plugin for checking security vulnerabilities in dependencies";
    homepage = "https://github.com/opeco17/poetry-audit-plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
