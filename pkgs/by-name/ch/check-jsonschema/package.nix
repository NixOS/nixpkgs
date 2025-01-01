{
  lib,
  fetchFromGitHub,
  python3,
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "check-jsonschema";
  version = "0.29.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-jsonschema";
    repo = "check-jsonschema";
    rev = "refs/tags/${version}";
    hash = "sha256-JSz8zwiOnX3nuKypffe0wZ7YoZ7uHH/lAoUgdKfkEO8=";
  };

  propagatedBuildInputs = [
    ruamel-yaml
    jsonschema
    requests
    click
    regress
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    responses
  ];

  pythonImportsCheck = [
    "check_jsonschema"
    "check_jsonschema.cli"
  ];

  disabledTests = [
    "test_schemaloader_yaml_data"
  ];

  meta = with lib; {
    description = "Jsonschema CLI and pre-commit hook";
    mainProgram = "check-jsonschema";
    homepage = "https://github.com/python-jsonschema/check-jsonschema";
    changelog = "https://github.com/python-jsonschema/check-jsonschema/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ sudosubin ];
  };
}
