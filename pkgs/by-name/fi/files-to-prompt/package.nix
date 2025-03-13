{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "files-to-prompt";
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "files-to-prompt";
    tag = version;
    hash = "sha256-LWp/DNP3bsh7/goQGkpi4x2N11tRuhLVh2J8H6AUH0w=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Concatenate a directory full of files into a single prompt for use with LLMs";
    homepage = "https://github.com/simonw/files-to-prompt/";
    changelog = "https://github.com/simonw/files-to-prompt/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erethon ];
    mainProgram = "files-to-prompt";
  };
}
