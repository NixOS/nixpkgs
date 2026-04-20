{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "check-jsonschema";
  version = "0.37.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-jsonschema";
    repo = "check-jsonschema";
    tag = finalAttrs.version;
    hash = "sha256-DbEzK2G5Y/9eZF7oX2xIz7gtQ++Cwe+W26+ByaeHBiA=";
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
    changelog = "https://github.com/python-jsonschema/check-jsonschema/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sudosubin ];
  };
})
