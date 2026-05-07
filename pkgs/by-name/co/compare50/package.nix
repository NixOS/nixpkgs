{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "compare50";
  version = "1.2.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "compare50";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qRESVE9242Leo6js+YrRrLff7C3IjWFKSN2/GsC/8VA=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace-fail \
      'scripts=["bin/compare50"]' 'entry_points={"console_scripts": ["compare50=compare50.__main__:main"]}'
    # auto included in current python version, no install needed
    substituteInPlace setup.py --replace-fail \
      'importlib' ' '
  '';

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    attrs
    intervaltree
    jinja2
    lib50
    numpy
    packaging
    pygments
    termcolor
    tqdm
  ];

  pythonRelaxDeps = [
    "attrs"
    "numpy"
    "termcolor"
  ];

  pythonImportsCheck = [ "compare50" ];

  nativeCheckInputs = [ versionCheckHook ];

  # repo does not use pytest
  checkPhase = ''
    runHook preCheck

    ${python3Packages.python.interpreter} -m tests

    runHook postCheck
  '';

  meta = {
    description = "Tool for detecting similarity in code supporting over 300 languages";
    homepage = "https://cs50.readthedocs.io/projects/compare50/en/latest/";
    downloadPage = "https://github.com/cs50/compare50";
    changelog = "https://github.com/cs50/compare50/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "compare50";
  };
})
