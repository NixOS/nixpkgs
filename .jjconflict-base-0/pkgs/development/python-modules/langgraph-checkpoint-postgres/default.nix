{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenvNoCC,

  # build system
  poetry-core,

  # dependencies
  langgraph-checkpoint,
  ormsgpack,
  psycopg,
  psycopg-pool,

  # testing
  pgvector,
  postgresql,
  postgresqlTestHook,
  pytestCheckHook,
  pytest-asyncio,

  # passthru
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint-postgres";
  version = "2.0.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpointpostgres==${version}";
    hash = "sha256-hl1EBOtUkSfHGxsM+LOZPLSvkW7hdHS08klpvA7/Bd0=";
  };

  postgresqlTestSetupPost = ''
    substituteInPlace tests/conftest.py \
      --replace-fail "DEFAULT_URI = \"postgres://postgres:postgres@localhost:5441/postgres?sslmode=disable\"" "DEFAULT_URI = \"postgres:///$PGDATABASE\"" \
      --replace-fail "DEFAULT_POSTGRES_URI = \"postgres://postgres:postgres@localhost:5441/\"" "DEFAULT_POSTGRES_URI = \"postgres:///\""
  '';

  sourceRoot = "${src.name}/libs/checkpoint-postgres";

  build-system = [ poetry-core ];

  dependencies = [
    langgraph-checkpoint
    ormsgpack
    psycopg
    psycopg-pool
  ];

  pythonRelaxDeps = [
    "langgraph-checkpoint"
    "psycopg-pool"
  ];

  doCheck = !(stdenvNoCC.hostPlatform.isDarwin);

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    (postgresql.withPackages (p: with p; [ pgvector ]))
    postgresqlTestHook
  ];

  preCheck = ''
    export postgresqlTestUserOptions="LOGIN SUPERUSER"
  '';

  disabledTests = [
    # psycopg.errors.FeatureNotSupported: extension "vector" is not available
    # /nix/store/...postgresql-and-plugins-16.4/share/postgresql/extension/vector.control": No such file or directory.
    "test_embed_with_path"
    "test_embed_with_path_sync"
    "test_scores"
    "test_search_sorting"
    "test_vector_store_initialization"
    "test_vector_insert_with_auto_embedding"
    "test_vector_update_with_embedding"
    "test_vector_search_with_filters"
    "test_vector_search_pagination"
    "test_vector_search_edge_cases"
  ];

  pythonImportsCheck = [ "langgraph.checkpoint.postgres" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "checkpointpostgres==(\\d+\\.\\d+\\.\\d+)"
    ];
  };

  meta = {
    description = "Library with a Postgres implementation of LangGraph checkpoint saver";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint-postgres";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/checkpointpostgres==${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      sarahec
    ];
  };
}
