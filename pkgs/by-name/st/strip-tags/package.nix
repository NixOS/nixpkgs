{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "strip-tags";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "strip-tags";
    tag = version;
    hash = "sha256-Oy4xii668Y37gWJlXtF0LgU+r5seZX6l2SjlqLKzaSU=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    beautifulsoup4
    click
    html5lib
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pyyaml
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "CLI tool for stripping tags from HTML";
    homepage = "https://github.com/simonw/strip-tags";
    changelog = "https://github.com/simonw/strip-tags/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erethon ];
    mainProgram = "strip-tags";
  };
}
