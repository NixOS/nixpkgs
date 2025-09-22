{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "snallygaster";
  version = "0.0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hannob";
    repo = "snallygaster";
    tag = "v${version}";
    hash = "sha256-H5rptK12p5dRKYjoQ6Nr8hxq8pL/3jFDgX1gnRZABTo=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    dnspython
    lxml
    urllib3
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  disabledTestPaths = [
    # we are not interested in linting the project
    "tests/test_codingstyle.py"
  ];

  meta = with lib; {
    description = "Tool to scan for secret files on HTTP servers";
    homepage = "https://github.com/hannob/snallygaster";
    changelog = "https://github.com/hannob/snallygaster/releases/tag/${src.tag}";
    license = licenses.bsd0;
    maintainers = with maintainers; [ fab ];
    mainProgram = "snallygaster";
  };
}
