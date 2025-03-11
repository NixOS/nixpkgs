{
  lib,
  python3Packages,
  fetchFromGitHub,
  stdenv,
  python3,
}:
python3Packages.buildPythonApplication rec {
  pname = "gpt-cli";
  version = "0.3.2";
  format = "pyproject";

  SHELL = "${stdenv.shell}";

  src = fetchFromGitHub {
    owner = "kharvd";
    repo = "gpt-cli";
    tag = "v${version}";
    hash = "sha256-Zmqhdh+XMvJ3bhW+qkQOJT3nf+8luv7aJGW6xJSPuns=";
  };

  pythonRelaxDeps = [
    "anthropic"
    "black"
    "google-generativeai"
    "openai"
    "pydantic"
    "attrs"
  ];

  build-system = with python3.pkgs; [
    pip
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    anthropic
    attrs
    black
    cohere
    google-generativeai
    openai
    prompt-toolkit
    pytest
    pyyaml
    rich
    typing-extensions
    pydantic
  ];

  meta = {
    description = "Command-line interface for ChatGPT, Claude and Bard";
    homepage = "https://github.com/kharvd/gpt-cli";
    changelog = "https://github.com/kharvd/gpt-cli/releases/tag/v${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _404wolf ];
  };
}
