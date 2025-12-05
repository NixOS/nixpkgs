{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "online-judge-verify-helper";
  version = "5.6.0";
  pyproject = true;
  disabled = python3Packages.pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "online-judge-tools";
    repo = "verification-helper";
    tag = "v${version}";
    hash = "sha256-sBR9/rf8vpDRbRD8HO2VNmxVckXPmPjUih7ogLRFaW8=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    colorlog
    importlab
    online-judge-tools
    pyyaml
    setuptools
    toml
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  # No additional dependencies or network access
  disabledTestPaths = [
    "tests/test_docs.py"
    "tests/test_python.py"
    "tests/test_rust.py"
    "tests/test_stats.py"
    "tests/test_verify.py"
  ];

  pythonImportsCheck = [
    "onlinejudge"
    "onlinejudge_bundle"
    "onlinejudge_verify"
    "onlinejudge_verify_resources"
  ];

  meta = {
    description = "Testing framework for snippet libraries used in competitive programming";
    mainProgram = "oj-verify";
    homepage = "https://github.com/online-judge-tools/verification-helper";
    changelog = "https://github.com/online-judge-tools/verification-helper/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toyboot4e ];
  };
}
