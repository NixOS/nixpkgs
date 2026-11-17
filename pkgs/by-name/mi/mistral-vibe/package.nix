{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  callPackage,
  rustPlatform,

  # tests
  gitMinimal,
  uv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      # Upstream pins mcp==1.28.1; v2's OAuthClientProvider subclasses httpx2.Auth,
      # which httpx rejects as the auth of the MCP OAuth flow
      mcp = final.mcp_1;
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mistral-vibe";
  version = "3.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-vibe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W1gpG0eZYXbY4j3/dtOMpvIznLAmNDYGkXdJJvaA6eA=";
  };

  patches = [
    # os.nice() fails with EPERM in the sandbox
    ./tolerate-unavailable-nice.patch
  ];

  postPatch =
    # The e2e tests expect the `vibe` executables to sit next to the Python interpreter
    ''
      substituteInPlace tests/e2e/common.py \
        --replace-fail \
          'Path(sys.executable).with_name(' \
          "Path('$out/bin/vibe').with_name("
    '';

  # The Unified Harness native extension (`mistralai_vibe_local_harness._native`)
  cargoRoot = "harness/core";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.cargoRoot}";
    hash = "sha256-JkmZ65pnioLfTLg9Nmtsjs4m6lB72c6iTKvnwz48Gqo=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  env = {
    # The v8 crate would otherwise download these at build time
    RUSTY_V8_ARCHIVE = finalAttrs.passthru.librusty_v8.archive;
    RUSTY_V8_SRC_BINDING_PATH = finalAttrs.passthru.librusty_v8.srcBinding;
  };

  # Replicate what upstream's custom build backend (build_backend/maturin_backend.py)
  # does before handing over to maturin, without its zig/manylinux portability
  # tweaks and with the Rust TUI built separately.
  preBuild = ''
    mkdir -p .native-build
    cp -r harness/core .native-build/harness-core
    cp -r harness/runtimes/python/python/mistralai_vibe_local_harness .

    mkdir -p vibe/_bin
    cp ${lib.getExe finalAttrs.passthru.vibe-rs} vibe/_bin/vibe-rs
  '';

  pythonRelaxDeps = true;
  dependencies =
    with pythonPackages;
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
      croniter
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
      miniaudio
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
      rfc8785
      rich
      rpds-py
      sentry-sdk
      setproctitle
      six
      smmap
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
    pythonPackages.pyte
    pythonPackages.pytest-asyncio
    pythonPackages.pytest-textual-snapshot
    pythonPackages.pytest-xdist
    pythonPackages.pytestCheckHook
    pythonPackages.respx
    pythonPackages.tomlkit
    uv
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  # Make sure that the installed runtime, which ships the native extension, is imported
  preCheck = ''
    rm -rf mistralai_vibe_local_harness
  '';

  disabledTests = [
    # AssertionError: assert <MCPSourceStatus.UNAVAILABLE: 'unavailable'> is <MCPSourceStatus.ENABLED: 'enabled'>
    "test_mcp_catalog_read_refresh_toggle_remove_and_compatibility_aliases"

    # vibe.core.llm.exceptions.BackendError: LLM backend error [mock-provider]
    # reason: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: Missing Authority Key Identifier (_ssl.c:1032)
    "test_generic_backend_streaming_uses_ssl_cert_file"

    # TypeError: cannot pickle 'itertools.count' object (Python 3.14 compatibility)
    "test_orchestrator_deepcopies_and_stays_functional"

    # The sandbox helper runs `python3 -I`, which cannot import the harness runtime
    # assert 3 == 1
    "test_a_sandbox_without_skills_of_its_own_needs_no_upload"

    # An extra notification is emitted because connectors fail to load (no network)
    "test_opening_a_unified_session_notifies_invalid_managed_config"

    # Flaky: TimeoutError
    "test_unified_host_reads_the_live_public_event_cursor"

    # Flaky: session references are not yet garbage-collected
    "test_closed_sessions_release_their_servers_and_background_tasks"

    # Both writes land in the same coarse filesystem timestamp tick, so the
    # (device, inode, mtime, size) fingerprint does not change
    "test_changes_when_file_changes"

    # Upstream pins mistralai==2.6.0, whose `create_or_update_user_credentials_async`
    # was replaced by `create_credentials_async` in later versions
    "test_connect_http_failure_reads_as_a_sentence_without_the_body"
    "test_connect_turns_a_no_auth_connector_into_a_connected_one"
    "test_connect_without_credentials_creates_the_default_user_connection"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert 'alive' == 'gone'
    "test_background_processes_answer_the_model_alike_on_the_host_and_in_a_sandbox"

    # RuntimeError: Session lease file watcher did not start
    "test_unified_lease_subscription_ends_with_its_connection"
    "test_unified_lease_subscription_reports_held_sessions_then_changes"
  ];

  disabledTestPaths = [
    # All snapshot tests use syrupy 4.8.0, which is not packaged here.
    "tests/snapshots/"

    # These tests invoke uv run and fail to import the packaged pydantic extension.
    "tests/e2e/agent_loop_characterization/test_resume.py"
    "tests/e2e/agent_loop_characterization/test_subagents.py"
    "tests/e2e/agent_loop_characterization/test_tool_execution.py"
    "tests/e2e/agent_loop_characterization/test_tool_permissions.py"
    "tests/e2e/agent_loop_characterization/test_user_interaction.py"
    "tests/e2e/test_cli_tui_hooks.py"
    "tests/e2e/test_cli_tui_onboarding.py"
    "tests/e2e/test_cli_tui_session_exit.py"
    "tests/e2e/test_cli_tui_streaming.py"
    "tests/e2e/test_cli_tui_tool_approval.py"

    # ACP tests require network access
    "tests/acp/test_acp_entrypoint_smoke.py"

    # The installer is run with a PATH restricted to /usr/bin:/bin, where the
    # sandbox provides no `bash`
    "tests/test_install_script.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: Session lease file watcher did not start
    "tests/app_server/test_session_lease_watch.py"
  ];

  __darwinAllowLocalNetworking = true;

  passthru = {
    librusty_v8 = callPackage ./librusty_v8.nix { };
    vibe-rs = callPackage ./vibe-rs.nix {
      inherit (finalAttrs) version src meta;
    };
  };

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
