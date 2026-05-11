{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "amoco";
  version = "2.9.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdcht";
    repo = "amoco";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3+1ssFyU7SKFJgDYBQY0kVjmTHOD71D2AjnH+4bfLXo=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    blessed
    click
    crysp
    grandalf
    pyparsing
    tqdm
    traitlets
  ];

  optional-dependencies = {
    app = with python3.pkgs; [
      # ccrawl
      ipython
      prompt-toolkit
      pygments
      # pyside6
      z3-solver
    ];
  };

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  pythonRelaxDeps = [
    "grandalf"
    "crysp"
  ];

  pythonImportsCheck = [
    "amoco"
  ];

  disabledTests = [
    # AttributeError: 'str' object has no attribute '__dict__'
    "test_func"
  ];

  meta = {
    description = "Tool for analysing binaries";
    mainProgram = "amoco";
    homepage = "https://github.com/bdcht/amoco";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
