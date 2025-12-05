{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "ghmap";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uhourri";
    repo = "ghmap";
    tag = "v${version}";
    hash = "sha256-mNWBClKs5QnjwMMWS/OaxgD0g0D0bWRx8ecyG3+zy+s=";
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
    maintainers = [ ];
    mainProgram = "ghmap";
  };
}
