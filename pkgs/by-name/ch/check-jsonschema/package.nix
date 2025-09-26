{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "check-jsonschema";
  version = "0.34.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-jsonschema";
    repo = "check-jsonschema";
    tag = version;
    hash = "sha256-NFP013ZG+Ltiqe+CLed4zeSQCS9E1r1L+b2AsYLMDW4=";
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
