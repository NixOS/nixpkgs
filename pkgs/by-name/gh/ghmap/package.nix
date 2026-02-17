{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ghmap";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uhourri";
    repo = "ghmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UF7Zxrm+thZeAKPiCaI5t4NbDzuUU3oosPsb0Cgv9t0=";
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
})
