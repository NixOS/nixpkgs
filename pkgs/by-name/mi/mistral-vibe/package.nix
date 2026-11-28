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
  version = "3.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-vibe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yGJHCg4R9zOiY+tfxyOSCUOtqr7dBna59zcGSwp0WkI=";
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
    hash = "sha256-HGYTsDY9XOprkaJfPM7ECzyeugBGiGCwyYXr1UFvVxc=";
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
  pythonRemoveDeps = [
    # Not packaged in nixpkgs, and not imported by vibe
    "opentelemetry-exporter-otlp-common"
    # Not packaged in nixpkgs. Provides the `mistralai.vibe.harness` target runtime,
    # which vibe itself does not import (only tests/app_server/test_session_api_rename.py)
    "mistralai-vibe-harness"
  ];
  dependencies =
    with python3Packages;
    [
      agent-client-protocol
      annotated-types
      anyio
      attrs
      authlib
      beautifulsoup4
      brotli
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
      httpcore2
      httpx
      httpx2
      humanize
      idna
      jaraco-classes
      jaraco-context
      jaraco-functools
      joserfc
      jsonpatch
      jsonpath-python
      jsonpointer
      jsonschema
      jsonschema-specifications
      keyring
      markdownify
      mcp
      mcp-types
      miniaudio
      mistralai
      more-itertools
      opentelemetry-api
      opentelemetry-exporter-http-transport
      opentelemetry-exporter-otlp-proto-common
      opentelemetry-exporter-otlp-proto-http
      opentelemetry-proto
      opentelemetry-sdk
      opentelemetry-semantic-conventions
      packaging
      pexpect
      protobuf
      ptyprocess
      pyasn1
      pyasn1-modules
      pycparser
      pydantic
      pydantic-core
      pydantic-settings
      pyjwt
      python-dateutil
      python-dotenv
      python-multipart
      pyyaml
      referencing
      requests
      rfc8785
      rpds-py
      sentry-sdk
      setproctitle
      six
      smmap
      socksio
      soupsieve
      sse-starlette
      starlette
      structlog
      tenacity
      tomli-w
      tree-sitter
      tree-sitter-bash
      truststore
      typing-extensions
      typing-inspection
      urllib3
      uuid-utils
      uvicorn
      watchfiles
      websockets
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      jeepney
      secretstorage
    ];

  pythonImportsCheck = [ "vibe" ];

  nativeCheckInputs = [
    # vibe.core.agent_loop.TeleportError: Teleport requires git to be installed.
    gitMinimal
    python3Packages.pyte
    python3Packages.pytest-asyncio
    python3Packages.pytest-xdist
    python3Packages.pytestCheckHook
    python3Packages.respx
    python3Packages.rich
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
    # AssertionError: assert <MCPSourceStatus.UNAVAILABLE: 'unavailable'> is <MCPSourceStatus.ENABLED: 'enabled'>
    "test_mcp_catalog_read_refresh_toggle_remove_and_compatibility_aliases"
    "test_local_mcp_servers_stay_usable_when_connectors_reject_the_key"

    # TypeError: cannot pickle 'itertools.count' object (Python 3.14 compatibility)
    "test_orchestrator_deepcopies_and_stays_functional"

    # The sandbox helper runs `python3 -I`, which cannot import the harness runtime
    # assert 3 == 1
    "test_a_sandbox_without_skills_of_its_own_needs_no_upload"

    # An extra notification is emitted because connectors fail to load (no network)
    "test_opening_a_unified_session_notifies_invalid_managed_config"

    # Flaky: TimeoutError
    "test_unified_host_reads_the_live_public_event_cursor"

    # Flaky: RuntimeError: A turn is already running
    "test_a_forked_child_can_be_forked_again_onto_an_inherited_turn"

    # Flaky: session references are not yet garbage-collected
    "test_closed_sessions_release_their_servers_and_background_tasks"

    # Both writes land in the same coarse filesystem timestamp tick, so the
    # (device, inode, mtime, size) fingerprint does not change
    "test_changes_when_file_changes"

    # TypeError: OTLPSpanExporter.__init__() got an unexpected keyword argument '_transport'
    # (requires opentelemetry-exporter-otlp-proto-http>=1.45.0)
    "test_trace_export_swaps_each_batch_and_keeps_tenant_headers"

    # Disk usage is measured from allocated blocks, which depends on the build filesystem
    # e.g. assert 512 >= 80000
    "test_a_bucket_folder_that_is_no_worktree_goes_to_other_vibe_data"
    "test_an_entry_with_an_unknown_device_is_still_counted"
    "test_an_orphan_child_goes_to_other_vibe_data"
    "test_a_subagent_child_folds_into_its_root_session"
    "test_a_worktree_of_archived_sessions_only_is_a_leftover"
    "test_a_write_during_the_last_turn_triggers_a_re_measure"
    "test_legacy_folders_and_other_session_data_go_to_other_vibe_data"
    "test_worktree_layout_bucket_unclaimed_and_not_a_bucket"
    "test_a_home_behind_a_symlink_counts_each_history_once"
    "test_measuring_around_excluded_folders_never_enters_a_junction"
    "test_the_portable_walk_never_enters_a_junction"

    # Failed: DID NOT RAISE WorkspaceTrustError
    "test_a_name_longer_than_the_system_allows_is_an_error"
    "test_a_path_inside_an_unreadable_folder_is_an_error"

    # The fake stdio MCP server cannot be reached through the harness in the sandbox
    # LocalToolFailure: `fake` is configured on this computer but could not be reached
    "test_a_call_retunes_only_its_own_server"
    "test_a_call_to_one_server_keeps_the_others_connected"
    "test_an_allow_that_rests_on_read_only_is_checked_on_the_route_that_runs"
    "test_a_real_server_that_outlasts_the_deadline_times_out"
    "test_a_real_stdio_server_is_listed_and_called_through_the_harness"
    "test_the_list_leaves_out_tools_the_user_turned_off"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert 'alive' == 'gone'
    "test_background_processes_answer_the_model_alike_on_the_host_and_in_a_sandbox"

    # RuntimeError: Session lease file watcher did not start
    "test_unified_lease_subscription_ends_with_its_connection"
    "test_unified_lease_subscription_reports_held_sessions_then_changes"

    # The skill file watcher never reports changes in the sandbox (TimeoutError)
    "test_a_configured_skill_path_created_later_is_picked_up"
    "test_a_new_skill_file_yields_one_change"
    "test_a_skill_written_after_the_session_opened_is_picked_up_without_reload"
    "test_a_watch_with_nothing_to_watch_waits_for_a_folder"

    # The file watch never sees the other process's write in the sandbox (TimeoutError)
    "test_a_read_by_another_process_reaches_the_owners"

    # The killed shell's stdout does not close in time (TimeoutError)
    "test_killing_a_shell_right_after_its_first_output_kills_its_next_command"
  ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'mistralai.vibe' (mistralai-vibe-harness is not packaged)
    "tests/app_server/test_session_api_rename.py"

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

    # Flaky: telemetry events are not received in the expected order
    "tests/app_server/test_setup_oidc_telemetry.py"

    # ACP tests require network access
    "tests/acp/test_acp_entrypoint_smoke.py"

    # The installer is run with a PATH restricted to /usr/bin:/bin, where the
    # sandbox provides no `bash`
    "tests/test_install_script.py"
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
    changelog = "https://github.com/mistralai/mistral-vibe/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      shikanime
      mana-byte
    ];
    mainProgram = "vibe";
  };
})
