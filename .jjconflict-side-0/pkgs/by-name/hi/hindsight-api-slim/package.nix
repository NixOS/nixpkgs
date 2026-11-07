{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hindsight-api-slim";
  version = "1.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vectorize-io";
    repo = "hindsight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0+BuUhlf3mljlo9F9cVLcnOORZhMlK1mFY7Cqem6oYs=";
  };

  sourceRoot = "${finalAttrs.src.name}/hindsight-api-slim";

  build-system = with python3Packages; [ hatchling ];

  pythonRemoveDeps = [
    # Not packaged in nixpkgs, and only used by the optional Copilot LLM provider
    "github-copilot-sdk"
  ];

  pythonRelaxDeps = [
    "opentelemetry-api"
    "opentelemetry-sdk"
    "opentelemetry-instrumentation-fastapi"
    "opentelemetry-exporter-prometheus"
    "opentelemetry-exporter-otlp-proto-http"
    "opentelemetry-semantic-conventions"
    "regex"
    "greenlet"
  ];

  dependencies =
    with python3Packages;
    [
      aiohttp
      alembic
      anthropic
      asyncpg
      authlib
      boto3
      claude-agent-sdk
      cohere
      croniter
      cryptography
      dateparser
      fastapi
      fastmcp
      filelock
      google-auth
      google-genai
      greenlet
      httpx
      json-repair
      litellm
      markitdown # nixpkgs' markitdown already includes the extras' deps
      numpy
      obstore
      openai
      opentelemetry-api
      opentelemetry-exporter-otlp-proto-http
      opentelemetry-exporter-prometheus
      opentelemetry-instrumentation-fastapi
      opentelemetry-sdk
      opentelemetry-semantic-conventions
      orjson
      pgvector
      pillow
      protobuf
      psycopg2-binary
      pyasn1
      pydantic
      pygments
      pyjwt
      python-dateutil
      python-dotenv
      python-multipart
      regex
      rich
      sqlalchemy
      toktok-rs
      typer
      urllib3
      uvicorn
      uvloop
      wsproto
    ]
    ++ fastapi.optional-dependencies.standard;

  # Suite is large (> 10,000 tests) and flaky under load/xdist
  doCheck = false;

  pythonImportsCheck = [
    "hindsight_api"
    "hindsight_api.main"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Agent memory server that learns from interactions, with pluggable LLM/embedding providers";
    longDescription = ''
      Hindsight is a memory layer for AI agents: it ingests conversation and
      document content, extracts and links durable facts, and serves them
      back through a recall API. hindsight-api-slim is the base distribution
      of the FastAPI server and worker, relying on external LLM/embedding
      providers (OpenAI, Anthropic, Cohere, Google, or a self-hosted
      OpenAI-compatible endpoint) rather than bundling local ML models.
    '';
    homepage = "https://hindsight.vectorize.io/";
    changelog = "https://github.com/vectorize-io/hindsight/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ brudel ];
    mainProgram = "hindsight-api";
  };
})
