{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "gpt-cli";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kharvd";
    repo = "gpt-cli";
    tag = "v${version}";
    hash = "sha256-BNSMxf3rhKieXYnFqVdpiHmNCDjotJUflwa6mAgsVCc=";
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
    google-genai
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
    changelog = "https://github.com/kharvd/gpt-cli/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _404wolf ];
    mainProgram = "gpt";
  };
}
