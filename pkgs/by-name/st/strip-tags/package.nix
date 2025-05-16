{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "strip-tags";
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "strip-tags";
    tag = version;
    hash = "sha256-K+rImwURcN6UWjmFt7Y3YLC5s07zPAT5Xqd0k+3J9/s=";
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
  versionCheckProgramArg = "--version";

  meta = {
    description = "CLI tool for stripping tags from HTML";
    homepage = "https://github.com/simonw/strip-tags";
    changelog = "https://github.com/simonw/strip-tags/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erethon ];
    mainProgram = "strip-tags";
  };
}
