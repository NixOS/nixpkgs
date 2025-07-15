{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "submit50";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "submit50";
    tag = "v${version}";
    hash = "sha256-i1hO9P3FGamo4b733/U7d2fiWLdnTskrHM2BXxxDePc=";
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
    changelog = "https://github.com/cs50/submit50/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "submit50";
  };
}
