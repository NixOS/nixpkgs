{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "submit50";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "submit50";
    tag = "v${version}";
    hash = "sha256-D71d8f2XfLrsDRBuEZK7B96UTUkJLkHsCWchDNO8epI=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    lib50
    packaging
    pytz
    requests
    termcolor
  ];

  pythonImportsCheck = [ "submit50" ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  # no python tests

  meta = {
    description = "Tool for submitting student CS50 code";
    homepage = "https://cs50.readthedocs.io/submit50/";
    downloadPage = "https://github.com/cs50/submit50";
    changelog = "https://github.com/cs50/submit50/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "submit50";
  };
}
