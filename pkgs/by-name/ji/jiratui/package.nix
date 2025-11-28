{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "jiratui";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "whyisdifficult";
    repo = "jiratui";
    tag = "v${version}";
    hash = "sha256-b5bSMPnqHqpeFDl501gSun7G38OlhV/IMNMYXQT+j/4=";
  };

  build-system = with python3Packages; [
    uv-build
  ];

  dependencies =
    with python3Packages;
    [
      click
      gitpython
      httpx
      pyaml
      pydantic-settings
      python-dateutil
      python-json-logger
      python-magic
      textual
      textual-image
      xdg-base-dirs
    ]
    ++ textual.optional-dependencies.syntax;

  pythonRelaxDeps = [
    "click"
  ];

  pythonImportsCheck = [
    "jiratui"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "A Textual User Interface for interacting with Atlassian Jira from your shell";
    homepage = "https://github.com/whyisdifficult/jiratui";
    changelog = "https://github.com/whyisdifficult/jiratui/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "jiratui";
  };
}
