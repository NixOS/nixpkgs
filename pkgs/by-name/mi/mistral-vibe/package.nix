{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,

  # tests
  gitMinimal,
  uv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mistral-vibe";
  version = "2.24.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-vibe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gDQl5UjSOyXg3l9yD1CXhfrSbUWUDYoquVvc2K4nv14=";
  };

  build-system = with python3Packages; [
    editables
    hatch-vcs
    hatchling
  ];

  pythonRelaxDeps = true;
  dependencies =
    with python3Packages;
    [
      agent-client-protocol
      annotated-types
      anyio
      attrs
      beautifulsoup4
      cachetools
      certifi
      cffi
      charset-normalizer
      click
      cryptography
      eval-type-backport
      gitdb
      gitpython
      giturlparse
      google-auth
      googleapis-common-protos
      h11
      httpcore
      httpx
      httpx-sse
      humanize
      idna
      importlib-metadata
      jaraco-classes
      jaraco-context
      jaraco-functools
      jsonpatch
      jsonpath-python
      jsonpointer
      jsonschema
      jsonschema-specifications
      keyring
      linkify-it-py
      markdown-it-py
      markdownify
      mcp
      mdit-py-plugins
      mdurl
      mistralai
      more-itertools
      opentelemetry-api
      opentelemetry-exporter-otlp-proto-common
      opentelemetry-exporter-otlp-proto-http
      opentelemetry-proto
      opentelemetry-sdk
      opentelemetry-semantic-conventions
      packaging
      pexpect
      platformdirs
      protobuf
      ptyprocess
      pyasn1
      pyasn1-modules
      pycparser
      pydantic
      pydantic-core
      pydantic-settings
      pygments
      pyjwt
      pyperclip
      python-dateutil
      python-dotenv
      python-multipart
      pyyaml
      referencing
      requests
      rich
      rpds-py
      sentry-sdk
      setproctitle
      six
      smmap
      sounddevice
      soupsieve
      sse-starlette
      starlette
      textual
      textual-speedups
      tomli-w
      tree-sitter
      tree-sitter-bash
      truststore
      typing-extensions
      typing-inspection
      uc-micro-py
      urllib3
      uvicorn
      watchfiles
      websockets
      zipp
      zstandard
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      jeepney
      secretstorage
    ];

  pythonImportsCheck = [ "vibe" ];

  nativeCheckInputs = [
    # vibe.core.agent_loop.TeleportError: Teleport requires git to be installed.
    gitMinimal
    python3Packages.pytest-asyncio
    python3Packages.pytest-textual-snapshot
    python3Packages.pytest-xdist
    python3Packages.pytestCheckHook
    python3Packages.respx
    python3Packages.tomlkit
    uv
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  disabledTests = [
    # vibe is spawned in a sub-process and fails to import `mcp`
    # ModuleNotFoundError: No module named 'mcp'
    "test_aclose_terminates_real_subprocess"
    "test_persists_real_subprocess_state_across_calls"

    # AssertionError: assert '32:2617357:1782120467963161870:7' != '32:2617357:1782120467963161870:7'
    "test_changes_when_file_changes"

    # vibe.core.llm.exceptions.BackendError: LLM backend error [mock-provider]
    # reason: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: Missing Authority Key Identifier (_ssl.c:1032)
    "test_generic_backend_streaming_uses_ssl_cert_file"

    # AssertionError: assert 0 == 1
    "test_preserves_accents_when_matching_latin1_encoded_file"

    # TypeError: cannot pickle 'itertools.count' object (Python 3.14 compatibility)
    "test_orchestrator_deepcopies_and_stays_functional"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError
    "test_rebuilds_index_when_mass_change_threshold_is_exceeded"
    "test_updates_index_incrementally_by_default"
    "test_updates_index_on_file_creation"
    "test_updates_index_on_file_deletion"
    "test_updates_index_on_file_rename"
    "test_updates_index_on_folder_rename"
    "test_watcher_toggle_flow_off_on_off"
  ];

  disabledTestPaths = [
    # This tests the install_script and fails. This is not relevant for nixpkgs.
    "tests/test_install_script.py"

    # All snapshot tests fail with AssertionError
    "tests/snapshots/"

    # These tests invoke uv run and fail to import the packaged pydantic extension.
    "tests/e2e/agent_loop_characterization/test_resume.py"
    "tests/e2e/agent_loop_characterization/test_subagents.py"
    "tests/e2e/agent_loop_characterization/test_tool_execution.py"
    "tests/e2e/agent_loop_characterization/test_tool_permissions.py"
    "tests/e2e/agent_loop_characterization/test_user_interaction.py"
    "tests/e2e/test_cli_tui_fresh_install.py"
    "tests/e2e/test_cli_tui_hooks.py"
    "tests/e2e/test_cli_tui_onboarding.py"
    "tests/e2e/test_cli_tui_session_exit.py"
    "tests/e2e/test_cli_tui_streaming.py"
    "tests/e2e/test_cli_tui_tool_approval.py"

    # ACP tests require network access
    "tests/acp/test_acp_entrypoint_smoke.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Minimal CLI coding agent by Mistral";
    homepage = "https://github.com/mistralai/mistral-vibe";
    changelog = "https://github.com/mistralai/mistral-vibe/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      shikanime
      mana-byte
    ];
    mainProgram = "vibe";
  };
})
