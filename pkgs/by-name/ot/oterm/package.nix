{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "oterm";
  version = "0.26.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ggozad";
    repo = "oterm";
    tag = finalAttrs.version;
    hash = "sha256-WlUgwOpXX4/AkCzWY+NYMSNVIXZyfpOEaXKYuXpBSJg=";
  };

  pythonRelaxDeps = true;

  build-system = with python3Packages; [ hatchling ];

  dependencies =
    with python3Packages;
    [
    aiosql
    aiosqlite
    ollama
    packaging
    pillow
      pydantic
      pydantic-ai-harness
      pydantic-ai-slim
    python-dotenv
      python-multipart
    textual
    textual-image
      textual-speedups
    textualeffects
    typer
    ]
    ++ pydantic-ai-slim.optional-dependencies.anthropic
    ++ pydantic-ai-slim.optional-dependencies.bedrock
    ++ pydantic-ai-slim.optional-dependencies.cohere
    ++ pydantic-ai-slim.optional-dependencies.duckduckgo
    ++ pydantic-ai-slim.optional-dependencies.google
    ++ pydantic-ai-slim.optional-dependencies.groq
    ++ pydantic-ai-slim.optional-dependencies.huggingface
    ++ pydantic-ai-slim.optional-dependencies.logfire
    ++ pydantic-ai-slim.optional-dependencies.mcp
    ++ pydantic-ai-slim.optional-dependencies.mistral
    ++ pydantic-ai-slim.optional-dependencies.openai
    ++ pydantic-ai-slim.optional-dependencies.web-fetch;

  pythonImportsCheck = [ "oterm" ];

  # Python tests require a HTTP connection to ollama

  # Fails on darwin with: PermissionError: [Errno 1] Operation not permitted: '/var/empty/Library'
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Text-based terminal client for Ollama";
    homepage = "https://github.com/ggozad/oterm";
    changelog = "https://github.com/ggozad/oterm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
    mainProgram = "oterm";
  };
})
