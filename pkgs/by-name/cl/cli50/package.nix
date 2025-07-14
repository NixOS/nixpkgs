{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "cli50";
  version = "8.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "cli50";
    tag = "v${version}";
    hash = "sha256-0gu31NPql8pFPN4jFbPwYkQmF/rbrAai6EY1ZVfXLew=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    inflect
    packaging
    requests
    tzlocal
  ];

  pythonImportsCheck = [ "cli50" ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  # no python tests

  meta = {
    description = "Mount directories into cs50/cli containers";
    homepage = "https://cs50.readthedocs.io/cli50/";
    downloadPage = "https://github.com/cs50/cli50";
    changelog = "https://github.com/cs50/cli50/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "cli50";
  };
}
