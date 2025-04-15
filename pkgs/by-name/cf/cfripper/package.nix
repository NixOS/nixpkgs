{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cfripper";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Skyscanner";
    repo = "cfripper";
    tag = "v${version}";
    hash = "sha256-xmCI+rM8Ijj66Df6H5WFpxTDkKqW5CPwXh+w/Qaqooc=";
  };

  pythonRelaxDeps = [
    "pluggy"
  ];

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = with python3.pkgs; [
  ];

  dependencies = with python3.pkgs; [
    boto3
    cfn-flip
    click
    pluggy
    pycfmodel
    pydash
    pyyaml
    setuptools
  ];

  nativeCheckInputs = with python3.pkgs; [
    moto
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests are failing
    "tests/test_boto3_client.py"
    "tests/config/test_pluggy.py"
  ];

  disabledTests = [
    # Assertion fails
    "test_multiple_resources_with_wildcard_resources_are_detected"
  ];

  pythonImportsCheck = [
    "cfripper"
  ];

  meta = with lib; {
    description = "Tool for analysing CloudFormation templates";
    homepage = "https://github.com/Skyscanner/cfripper";
    changelog = "https://github.com/Skyscanner/cfripper/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "cfripper";
  };
}
