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
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ggozad";
    repo = "oterm";
    tag = finalAttrs.version;
    hash = "sha256-3s/nNXLkK0i93Pw/bbg/tsUqA0F7TbxHIBOopDPuQ60=";
  };

  pythonRelaxDeps = [
    "aiosql"
    "aiosqlite"
    "ollama"
    "packaging"
    "pillow"
    "pydantic"
    "pydantic-ai-harness"
    "pydantic-ai-slim"
    "python-dotenv"
    "textual"
    "textual-image"
    "textual-speedups"
    "textualeffects"
    "typer"
  ];

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    aiosql
    aiosqlite
    ollama
    packaging
    pillow
    pydantic
    pydantic-ai-harness
    # pydantic-ai-slim and its extras, as required by oterm's pyproject.toml
    pydantic-ai-slim
    anthropic
    boto3
    cohere
    ddgs
    # fastmcp-slim[client], imported by oterm.tools.mcp (client + keyring/filetree/memory backends)
    authlib
    exceptiongroup
    fastmcp-slim
    mcp
    py-key-value-aio
    starlette
    aiofile
    anyio
    cachetools
    keyring
    google-genai
    groq
    huggingface-hub
    logfire
    markdownify
    mistralai
    openai
    opentelemetry-instrumentation-httpx
    python-dotenv
    python-multipart
    tiktoken
    textual
    textual-image
    textual-speedups
    textualeffects
    typer
  ]
  # extra: pydantic-ai-slim[huggingface] (marker-limited to these architectures)
  ++ lib.optionals (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64) [ hf-xet ];

  pythonImportsCheck = [ "oterm" ];

  # Python tests require a HTTP connection to ollama

  # Fails on darwin with: PermissionError: [Errno 1] Operation not permitted: '/var/empty/Library'
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    versionCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Text-based terminal client for Ollama";
    homepage = "https://github.com/ggozad/oterm";
    changelog = "https://github.com/ggozad/oterm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
    mainProgram = "oterm";
  };
})
