{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "check50";
  version = "3.3.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "check50";
    tag = "v${version}";
    hash = "sha256-+qyEMzAJG/fyIqj+0mk0HTxTlQk6sHZhvmfd9Hgj/aw=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    attrs
    beautifulsoup4
    jinja2
    lib50
    packaging
    pexpect
    pyyaml
    requests
    setuptools # required for import pkg_resources
    termcolor
  ];

  pythonImportsCheck = [ "check50" ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  # no python tests

  meta = {
    description = "Testing tool for checking student CS50 code";
    homepage = "https://cs50.readthedocs.io/projects/check50/en/latest/";
    downloadPage = "https://github.com/cs50/check50";
    changelog = "https://github.com/cs50/check50/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "check50";
  };
}
