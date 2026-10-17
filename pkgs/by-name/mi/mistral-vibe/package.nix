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

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mistral-vibe";
  version = "2.26.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-vibe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+LIobI41N01cZ7eLQWWhJIDdKj8YBRLjFwqqnSQdJ2c=";
  };

  patches = [
    # os.nice() fails with EPERM in the sandbox
    ./tolerate-unavailable-nice.patch
  ];

  postPatch =
    # The e2e tests expect the `vibe` executable to sit next to the Python interpreter
    ''
      substituteInPlace tests/e2e/common.py tests/e2e/conftest.py \
        --replace-fail \
          'str(Path(sys.executable).with_name("vibe"))' \
          "'$out/bin/vibe'"
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

  # Make sure that the installed runtime, which ships the native extension, is imported
  preCheck = ''
    rm -rf mistralai_vibe_local_harness
  '';

  disabledTests = [
    # The finite stdio input closes before all responses are flushed in the sandbox.
    "test_stdio_server_uses_the_same_json_rpc_lifecycle"

    # AssertionError: assert <MCPSourceStatus.UNAVAILABLE: 'unavailable'> is <MCPSourceStatus.ENABLED: 'enabled'>
    "test_mcp_catalog_read_refresh_toggle_remove_and_compatibility_aliases"

    # vibe is spawned in a sub-process and fails to import `mcp`
    # ModuleNotFoundError: No module named 'mcp'
    "test_aclose_terminates_real_subprocess"
    "test_persists_real_subprocess_state_across_calls"

    # vibe.core.llm.exceptions.BackendError: LLM backend error [mock-provider]
    # reason: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: Missing Authority Key Identifier (_ssl.c:1032)
    "test_generic_backend_streaming_uses_ssl_cert_file"

    # AssertionError: assert 0 == 1
    "test_preserves_accents_when_matching_latin1_encoded_file"

    # TypeError: cannot pickle 'itertools.count' object (Python 3.14 compatibility)
    "test_orchestrator_deepcopies_and_stays_functional"

    # Flaky: AssertionError: Timed out waiting for UI state
    "test_incomplete_stream_does_not_retry_ahead_of_queued_prompts"

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
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # AssertionError: Timed out waiting for UI state
    "test_rewind_preview_error_does_not_fail_worker"
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
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Flaky: the 0.5s double/triple click chain threshold expires on slow builders
    "tests/cli/textual_ui/test_chat_input_word_drag.py"
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
