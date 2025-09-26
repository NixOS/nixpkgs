{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "ghmap";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uhourri";
    repo = "ghmap";
    tag = "v${version}";
    hash = "sha256-liwkJfNp2Ozph3ummrh2GEshIlmVsG8Y8Pmm4lw2Ya8=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    tqdm
  ];

  pythonImportsCheck = [
    "ghmap"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = {
    description = "Python tool for mapping GitHub events to contributor activities";
    homepage = "https://github.com/uhourri/ghmap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ghmap";
  };
}
