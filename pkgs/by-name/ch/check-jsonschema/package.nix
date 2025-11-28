{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "check-jsonschema";
  version = "0.35.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-jsonschema";
    repo = "check-jsonschema";
    tag = version;
    hash = "sha256-IiNUgv0XZtTzCJjp/4jyTpw9MAyBFtuf3N4VFqatZVg=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    ruamel-yaml
    jsonschema
    requests
    click
    regress
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-xdist
    responses
    identify
  ];

  disabledTests = [ "test_schemaloader_yaml_data" ];

  pythonImportsCheck = [
    "check_jsonschema"
    "check_jsonschema.cli"
  ];

  meta = {
    description = "Jsonschema CLI and pre-commit hook";
    mainProgram = "check-jsonschema";
    homepage = "https://github.com/python-jsonschema/check-jsonschema";
    changelog = "https://github.com/python-jsonschema/check-jsonschema/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sudosubin ];
  };
}
