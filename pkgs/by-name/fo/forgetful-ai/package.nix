{
  lib,
  fetchFromGitHub,
  git,
  python3Packages,
  nix-update-script,
}:

let
  # fastmcp pulls in fastmcp-slim, which is not compatible with mcp 2.x
  # (`McpError` was renamed to `MCPError` there, so the import fails outright).
  # Pin the mcp 1.x line for this package's scope until fastmcp ships a release
  # built against mcp 2, as other packages in nixpkgs already do.
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      mcp = final.mcp_1;
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "forgetful-ai";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scottrbk";
    repo = "forgetful";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D5xOuN3s094owu04jCF7WbpY8Vxm4XIVDflUcvn4nB0=";
  };

  build-system = [
    pythonPackages.hatchling
    pythonPackages.hatch-vcs
  ];

  # hatch-vcs reads the version from git metadata, which the release tarball
  # does not carry, so the packaged version is supplied explicitly.
  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  dependencies =
    with pythonPackages;
    [
      aiosqlite
      alembic
      asyncpg
      certifi
      fastapi
      fastembed
      fastmcp
      filelock
      fsspec
      google-genai
      httpx
      ollama
      openai
      pgvector
      pillow
      platformdirs
      psycopg2-binary
      py-key-value-aio
      pydantic
      pydantic-settings
      pyjwt
      requests
      sqlalchemy
      sqlite-vec
      starlette
      tiktoken
      urllib3
      uvicorn
    ]
    ++ [
      # py-key-value-aio[filetree]
      pythonPackages.aiofile
      # sqlalchemy[asyncio]
      pythonPackages.greenlet
      # upstream depends on the legacy `dotenv` shim, which re-exports this
      pythonPackages.python-dotenv
    ];

  # Upstream pins all 30 runtime dependencies to exact versions. nixpkgs does not
  # honour upstream's pins by design, so those constraints cannot be met here;
  # dropping the version bounds keeps the check itself live, which is the part
  # worth keeping - it still fails if a declared distribution is genuinely absent
  # from the closure. Relaxing by name would be unsafe: the hook matches the name
  # literally, so relaxing `pydantic` would also rewrite `pydantic-settings` down
  # to a bare `pydantic` requirement.
  pythonRelaxDeps = true;

  # Upstream's metadata names the legacy `dotenv` distribution. nixpkgs ships that
  # module as `python-dotenv`, which is installed, so this is a naming error in the
  # metadata rather than a missing dependency.
  pythonRemoveDeps = [ "dotenv" ];

  # upstream lists pytest and pytest-asyncio under runtime dependencies, but
  # nothing in app/ or main.py imports them, so they belong to the checks.
  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
    pythonPackages.pytest-asyncio
    # test_harness_walkthrough shells out to git
    git
  ];

  # 33 of the 1125 collected tests cannot run in the build sandbox. The 30 names
  # below account for all 33, since several are parametrised. Each group is
  # labelled by the failure actually observed when it was left enabled.
  disabledTests = [
    # Need network: MCP/REST provider clients resolve over DNS and fastembed
    # downloads the BAAI/bge-small-en embedding model from HuggingFace. The last
    # two were previously mislabelled as version drift; both fail on an HTTPS
    # connection. The entity-plugin pair was run on its own inside the sandbox and
    # fails there, so it belongs with the network group rather than beside it by
    # assumption.
    "test_build_runtime_wires_registry_and_memory_service"
    "test_skills_flag_off_omits_skill_service_and_tools"
    "test_skills_flag_on_wires_skill_service_and_tools"
    "test_dispose_runtime_is_idempotent"
    "test_scope_ceiling_denies_write_tool_with_required_scope"
    "test_local_flag_forces_local_even_with_server_configured"
    "test_default_is_local_mode"
    "test_entity_plugin_rejects_blocked_tag"
    "test_query_memory_with_token_budget"
    "test_query_memory_with_linked_memories"
    "test_provenance_fields_in_query_results"
    "test_query_memory_records_access_for_primaries_and_linked"
    "test_unobsolete_restores_query_visibility_and_clears_fields"
    "test_execute_create_then_get_memory_roundtrips"
    "test_execute_unknown_tool_raises_error_naming_available_tools"
    "test_list_tools_and_tool_info_expose_registry_metadata"
    "test_entity_mcp_warn_update_shape_rejection_and_read_isolation"
    "test_entity_mcp_delete_warn_reject_and_unavailable"
    "test_entity_rest_warnings_errors_and_flat_update"
    "test_entity_rest_delete_warning_rejection_and_unavailability"
    "test_entity_rest_delete_without_plugin_stays_minimal_shape"
    "test_entity_mcp_warn_and_reject_create"
    "test_plugin_warning_coexists_with_obsolete_match_and_query_stays_clean"
    "test_local_entity_create_plugin_warnings"
    "test_local_entity_create_without_plugin_has_no_warnings_in_json"

    # These spawn a bare interpreter and import app.config.settings from it. The
    # test replaces PYTHONPATH instead of extending it, so the child interpreter
    # loses the closure and fails with `ModuleNotFoundError: No module named
    # 'dotenv'`. That works in a virtualenv, where the package and its
    # dependencies sit in the interpreter's own site-packages. A consequence of
    # packaging this as an application, not an upstream defect.
    "test_cwd_env_does_not_override_user_config"
    "test_shell_env_overrides_user_config"

    # Assert behaviour of the exact dependency versions upstream pins, and fail
    # against the newer majors nixpkgs ships: the openai SDK now passes a Timeout
    # object where a float is asserted, and dnspython no longer raises on a
    # service port above 65535. These need an upstream fix, not a packaging one.
    "test_configured_timeout_reaches_the_shared_sdk_client"
    "test_wks_rejects_service_above_65535"
    "test_trace_context_rejects_input_above_512_characters"
  ];

  # upstream CI runs pytest per directory rather than over the whole tree, and
  # only these subsets run without external services. tests/architecture needs
  # `grimp` (an unpackaged dev-only dependency of import-linter), tests/e2e
  # needs a real PostgreSQL, and tests/docker needs a docker daemon.
  pytestFlags = [
    "tests/integration"
  ];

  # the suite writes into the user data directories that platformdirs derives
  # from HOME, which is read-only in the build sandbox.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "app" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server providing persistent, semantically searchable memory for AI agents";
    homepage = "https://github.com/scottrbk/forgetful";
    changelog = "https://github.com/scottrbk/forgetful/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.twstagg ];
    mainProgram = "forgetful-ai";
    # Built and tested on x86_64-linux only. Deliberately not platforms.unix:
    # the dependency set carries compiled code (psycopg2-binary, sqlite-vec,
    # tiktoken) that has not been built for Darwin here.
    platforms = lib.platforms.linux;
  };
})
