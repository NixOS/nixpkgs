{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "gpt-cli";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kharvd";
    repo = "gpt-cli";
    tag = "v${version}";
    hash = "sha256-VUDkY0r1/2kSJ0afEIsuWg6JSZpKPVuRgUcmoucWBps=";
  };

  build-system = with python3Packages; [
    pip
    setuptools
  ];

  pythonRelaxDeps = true;

  dependencies = with python3Packages; [
    anthropic
    attrs
    black
    cohere
    google-generativeai
    openai
    prompt-toolkit
    pydantic
    pytest
    pyyaml
    rich
    typing-extensions
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytestCheckHook
    ]
    ++ [
      versionCheckHook
    ];
  versionCheckProgram = "${placeholder "out"}/bin/gpt";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Command-line interface for ChatGPT, Claude and Bard";
    homepage = "https://github.com/kharvd/gpt-cli";
    changelog = "https://github.com/kharvd/gpt-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _404wolf ];
    mainProgram = "gpt";
  };
}
