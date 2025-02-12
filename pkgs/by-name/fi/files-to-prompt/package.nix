{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "files-to-prompt";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "files-to-prompt";
    tag = version;
    hash = "sha256-gl3j0ok/hlFfIF3HhhzYrUZuNlAtU7y+Ej29sQv9tP4=";
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
    changelog = "https://github.com/simonw/files-to-prompt/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erethon ];
    mainProgram = "files-to-prompt";
  };
}
