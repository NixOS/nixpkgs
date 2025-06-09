{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "compare50";
  version = "1.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "compare50";
    tag = "v${version}";
    hash = "sha256-WiIaJI51Ld5o9/swPXE4CBHYo8Ev09TPN3V2M4pGJl0=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    attrs
    intervaltree
    jinja2
    lib50
    numpy
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
  versionCheckProgramArg = "--version";

  # no python tests

  meta = {
    description = "Tool for detecting similarity in code supporting over 300 languages";
    homepage = "https://cs50.readthedocs.io/projects/compare50/en/latest/";
    downloadPage = "https://github.com/cs50/compare50";
    changelog = "https://github.com/cs50/compare50/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "check50";
  };
}
