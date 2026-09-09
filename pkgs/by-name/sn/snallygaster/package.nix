{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "snallygaster";
  version = "0.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hannob";
    repo = "snallygaster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t6xNRPISlPaxlwW/infW9qnxguc/wF7XpbFPzZRcgDA=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    dnspython
    lxml
    urllib3
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  meta = {
    description = "Tool to scan for secret files on HTTP servers";
    homepage = "https://github.com/hannob/snallygaster";
    changelog = "https://github.com/hannob/snallygaster/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "snallygaster";
  };
})
