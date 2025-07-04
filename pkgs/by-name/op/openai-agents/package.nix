{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "openai-agents";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-agents-python";
    rev = "v${version}";
    hash = "sha256-2Kn+pG/pxl7ffBr54YFViNMnAkIy49Jy0njdb4PLhRI=";
  };

  build-system = with python3.pkgs; [
    hatchling
  ];

  dependencies = with python3.pkgs; [
    openai
    pydantic
    griffe
    typing-extensions
    requests
    mcp
    types-requests
  ];

  optional-dependencies = with python3.pkgs; {
    voice = [
      numpy
      websockets
    ];
    viz = [
      graphviz
    ];
    litellm = [
      # litellm package not available in nixpkgs yet
    ];
  };

  # Disable runtime dependencies check due to some optional dependencies
  dontCheckRuntimeDeps = true;

  # Tests require API keys and external services
  doCheck = false;

  meta = {
    description = "OpenAI Agents SDK - A lightweight, powerful framework for multi-agent workflows";
    longDescription = ''
      The OpenAI Agents SDK is a lightweight yet powerful framework for building
      multi-agent workflows. It is provider-agnostic, supporting the OpenAI Responses
      and Chat Completions APIs, as well as 100+ other LLMs.

      Features include:
      - Agents: LLMs equipped with instructions and tools
      - Handoffs: Allow agents to delegate to other agents for specific tasks
      - Guardrails: Enable the inputs to agents to be validated
      - Function tools: Turn any Python function into a tool
      - Tracing: Built-in tracing for debugging and monitoring
    '';
    homepage = "https://github.com/openai/openai-agents-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}