{
  lib,
  python3Packages,
  fetchFromGitHub,
  postgresql,
  postgresqlTestHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hindsight-api-slim";
  version = "0.10.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vectorize-io";
    repo = "hindsight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yeIaj0apz9hRa7zK1M2jwd4GjUrGQO+pmdgeQGmN5NY=";
  };

  sourceRoot = "${finalAttrs.src.name}/hindsight-api-slim";

  build-system = with python3Packages; [ hatchling ];

  pythonRemoveDeps = [
    # Not packaged in nixpkgs, and only used by the optional Copilot LLM
    # provider (whose CLI, github-copilot-cli, is unfree).
    "github-copilot-sdk"
  ];

  # Upstream floors are ahead of nixpkgs; verified working with nixpkgs versions.
  # opentelemetry-*: floors track 1.44.0/0.65b0 (sdk MetricReader kwarg)
  # regex, json-repair: floors are for upstream-documented crash/DoS fixes
  # boto3: bare floor with no documented upstream rationale
  pythonRelaxDeps = [
    "opentelemetry-api"
    "opentelemetry-sdk"
    "opentelemetry-instrumentation-fastapi"
    "opentelemetry-exporter-prometheus"
    "opentelemetry-exporter-otlp-proto-http"
    "opentelemetry-semantic-conventions"
    "regex"
    "json-repair"
    "boto3"
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
      markitdown # nixpkgs' markitdown already includes the [pdf,docx,pptx,xlsx,xls] extras' deps
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

  nativeCheckInputs = [
    (postgresql.withPackages (p: [ p.pgvector ]))
    postgresqlTestHook
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
    pytest-xdist
  ]);

  # Migrations run CREATE EXTENSION vector, which requires superuser.
  postgresqlTestUserOptions = "LOGIN SUPERUSER";

  # Point the suite at the hook's server instead of pg0, which downloads
  # PostgreSQL binaries at runtime.
  env = {
    PGUSER = "test_user";
    PGDATABASE = "test_db";
    HINDSIGHT_API_DATABASE_URL = "postgresql://test_user@/test_db";
  };

  # Upstream's per-test timeout can fail on loaded builders
  pytestFlags = [ "--timeout=0" ];

  # Real LLM providers, Oracle, and long-running tests.
  disabledTestMarks = [
    "integration"
    "hs_llm_mat"
    "hs_llm_core"
    "slow"
    "oracle"
  ];

  disabledTestPaths = [
    # Requires external CLIs (claude-code, cursor, llama.cpp server)
    "tests/test_claude_code_llm_isolation.py"
    "tests/test_cursor_llm.py"
    "tests/test_llamacpp_cache_type.py"
    "tests/test_llamacpp_server_lifecycle.py"
    # Requires Docker / container runtime
    "tests/test_container_detection.py"
    "tests/test_file_storage_s3.py"
    "tests/test_http_probe.py"
    "tests/test_onnx_cuda.py"
    "tests/test_onnx_runtime.py"
    # Downloads models from Hugging Face
    "tests/test_local_model_alignment.py"
    "tests/test_model_load_default_dtype.py"
    "tests/test_onnx_embeddings.py"
    # Spin up their own embedded PostgreSQL (pg0), ignoring
    # HINDSIGHT_API_DATABASE_URL; pg0 downloads binaries at runtime
    "tests/test_ensure_vector_no_global_index.py"
    "tests/test_migration_backsweep.py"
    "tests/test_migration_drop_access_count.py"
    "tests/test_migration_drop_v1_structured_content.py"
    "tests/test_migration_entities_bank_trgm.py"
    "tests/test_migration_entity_kind.py"
    "tests/test_migration_entity_maintenance_queue.py"
    "tests/test_migration_history_long_bank_id.py"
    "tests/test_migration_observation_search_vector_backfill.py"
    "tests/test_migration_remaining_bank_id_text.py"
    "tests/test_oversized_append_truncates_document.py"
    "tests/test_reprocess_force_reextract.py"
    "tests/test_retain_label_tag_projection.py"
    # Require real LLM provider API keys
    "tests/test_fact_extraction_analysis.py"
    "tests/test_fact_extraction_output_ratio.py"
    "tests/test_gemini_batch_integration.py"
    # github-copilot-sdk is removed via pythonRemoveDeps
    "tests/test_github_copilot_llm.py"
    "tests/test_llm_timeout_propagation.py::test_every_network_provider_receives_the_resolved_timeout[github-copilot-extra3]"
  ];

  disabledTests = [
    # Scans the repo source layout for aiohttp sessions; finds none from the build tree
    "test_every_production_session_decides_about_the_proxy"
    # Captured stdout is closed before the CLI reports print
    "test_both_reports_print_before_the_single_non_zero_exit"
    # Regional endpoint format differs with the nixpkgs google-genai version
    "test_llm_wrapper_vertexai_region_endpoint"
    # Flaky: races with other test files sharing the database under xdist
    "test_concurrent_workers_claim_different_tasks"
    # Flaky: wall-clock bound fails on loaded builders
    "test_budget_cuts_retries_short_and_bounds_wall_clock"
    # Flaky: depend on process-global OpenTelemetry state shared under xdist
    "test_incoming_traceparent_becomes_the_handlers_trace"
    "test_excluded_urls_are_configurable"
  ];

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
