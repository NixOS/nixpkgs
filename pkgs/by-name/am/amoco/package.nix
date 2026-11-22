{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "amoco";
  version = "2.9.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdcht";
    repo = "amoco";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gqnlhJ7aDlRxMOcdWjMPIRvZ56Fs8IKIehnmIiVjJZc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  pythonRelaxDeps = [
    "grandalf"
    "crysp"
  ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    blessed
    click
    crysp
    grandalf
    pyparsing
    rich
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

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [
    "amoco"
  ];

  disabledTests = [
    # AttributeError: 'str' object has no attribute '__dict__'
    "test_func"
  ];

  meta = {
    description = "Tool for analysing binaries";
    homepage = "https://github.com/bdcht/amoco";
    changelog = "https://github.com/bdcht/amoco/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "amoco";
  };
})
