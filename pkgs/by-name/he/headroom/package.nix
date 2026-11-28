{
  lib,
  cargo,
  fetchFromGitHub,
  fetchurl,
  linkFarm,
  python3,
  python3Packages,
  rustPlatform,
  rustc,
  stdenv,
  unzip,
  versionCheckHook,
  ast-grep,
  difftastic,
  scc,
  gitMinimal,
  pkg-config,
  oniguruma,
  sqlite,
  writableTmpDirAsHomeHook,
}:

let
  dependencies = with python3Packages; [
    anthropic
    ast-grep-cli
    click
    datasets
    fakeredis
    fastapi
    fastembed
    h2
    httpx
    jinja2
    litellm
    magika
    mcp
    numpy
    onnxruntime
    openai
    openpyxl
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-sdk
    orjson
    pillow
    pydantic
    python-socks
    pyyaml
    rapidocr
    rich
    scikit-learn
    sentence-transformers
    sentencepiece
    sqlite-vec
    tiktoken
    tomlkit
    torch
    trafilatura
    transformers
    tree-sitter
    tree-sitter-language-pack
    truststore
    uvicorn
    watchdog
    websockets
    xlrd
    zstandard
  ];

  bundledTools = [
    ast-grep
    difftastic
    scc
  ];

  tiktokenEncodings = linkFarm "tiktoken-encodings" [
    {
      name = "0ea1e91bbb3a60f729a8dc8f777fd2fc07cd8df4";
      path = fetchurl {
        url = "https://openaipublic.blob.core.windows.net/encodings/r50k_base.tiktoken";
        hash = "sha256-MGzSfwPBpxTspxCOA9ZrfcBCq+jCWLRMGZp+2YON2TA=";
      };
    }
    {
      name = "ec7223a39ce59f226a68acc30dc1af2788490e15";
      path = fetchurl {
        url = "https://openaipublic.blob.core.windows.net/encodings/p50k_base.tiktoken";
        hash = "sha256-lLXKff9NAHZ7wlb90bJ+Wxc2HXuKX5aFR/nyPrcNIGk=";
      };
    }
    {
      name = "9b5ad71b2ce5302211f9c61530b329a4922fc6a4";
      path = fetchurl {
        url = "https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken";
        hash = "sha256-Ijkht27pm96ZW3/3OFE+7xAPtR0YyTWXoRO8/+hlsqc=";
      };
    }
    {
      name = "fb374d419588a4632f3f557e76b4b70aebbca790";
      path = fetchurl {
        url = "https://openaipublic.blob.core.windows.net/encodings/o200k_base.tiktoken";
        hash = "sha256-RGqVOMtsNI41FhINfAiwn1fDZJXirP/+WaW/iwz7Gi0=";
      };
    }
  ];
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "headroom";
  version = "0.44.0";
  pyproject = true;

  # Many tests bind local sockets
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "headroomlabs-ai";
    repo = "headroom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t3hBnXKRzzMOFPFTyFu6+uV0QVGKJH4ZjIXQVG/4I5U=";
  };

  patches = [
    ./restore-cli-main-before-offline-check.patch
    ./preserve-sandbox-proxy-environment.patch
    # torch.mps.empty_cache() segfaults when no Metal device is available (e.g. Darwin sandbox)
    ./skip-mps-empty-cache-without-device.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-hhfYzkv7N/7L1Gv9I9RcnLRsrTjcRkBroo5ei5VbuHU=";
  };

  build-system = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonRelaxDeps = [
    # Upstream only raised these floors for CVE fixes
    "click"
  ];
  inherit dependencies;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    oniguruma
    sqlite
  ];

  makeWrapperArgs = [
    # Preserve PYTHONPATH because proxy startup re-execs `python -m headroom.cli`.
    "--prefix"
    "PYTHONPATH"
    ":"
    "${placeholder "out"}/${python3.sitePackages}:${python3Packages.makePythonPath dependencies}"

    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath bundledTools)

    # Bundle Tiktoken encodings instead of lazily downloading them.
    "--set"
    "TIKTOKEN_CACHE_DIR"
    tiktokenEncodings
  ];

  pythonImportsCheck = [ "headroom" ];

  # Counts refer to test functions (some are parametrized).
  disabledTests = [
    # These tests cover service/process management or platform behavior untestable in the sandbox.

    # tests/test_cache_optimizer_example_cleanup.py: 1/1 disabled
    # This subprocess replaces PYTHONPATH, losing Nix's dependencies.
    "test_cache_optimizer_example_keeps_ccr_in_memory"

    # tests/test_cli/test_mcp_reconcile.py: 1/18 disabled
    "test_ordinary_install_does_not_adopt_serena"

    # tests/test_cli_proxy_improvements.py: 2/58 disabled
    "test_ensure_proxy_dependencies_exits_when_fastapi_missing"
    "test_proxy_command_exits_when_mcp_missing"

    # tests/test_copilot_auth.py: 3/105 disabled
    "test_device_authorization_uses_form_encoded_request"
    "test_device_poll_uses_form_encoded_request"
    "test_exchange_token_sync_raises_for_http_error"

    # tests/test_graph.py: 1/6 disabled
    # /build is ignored by the watcher, so the main.py event never schedules a reindex.
    "test_code_graph_watcher_init_start_stop_and_event_filtering"

    # tests/test_hard_watchdog.py: 3/6 disabled
    # These subprocesses replace the environment, losing Nix's PYTHONPATH.
    "test_healthy_process_is_never_shot"
    "test_seized_gil_is_dumped_and_exited"
    "test_swapped_stderr_does_not_kill_the_heartbeat"

    # tests/test_image_compression_isolation.py: 2/14 disabled
    # Spawned workers do not start within the tight timeouts in the sandbox.
    "test_abandoned_queued_job_never_runs_while_peer_completes"
    "test_one_timeout_does_not_destroy_a_concurrent_request"

    # tests/test_install/test_native_installers.py: 2/10 disabled
    "test_bash_native_installer_supports_persistent_docker_lifecycle"
    "test_bash_native_wrapper_supports_opencode"

    # tests/test_install/test_runtime.py: 1/55 disabled
    "test_runtime_start_lock_blocks_another_process"

    # tests/test_install/test_supervisors.py: 1/50 disabled
    "test_install_supervisor_darwin_windows_and_unsupported"

    # tests/test_install_git_hooks_script.py: 5/7 disabled
    # The fake pre-commit script uses a /usr/bin/env shebang, unavailable in the sandbox.
    "test_installs_hooks_in_an_ordinary_checkout"
    "test_installs_shared_hooks_from_a_linked_worktree"
    "test_pre_push_runs_ci_precheck_for_a_branch_update"
    "test_pre_push_runs_ci_precheck_when_a_push_mixes_a_delete_and_an_update"
    "test_pre_push_skips_ci_precheck_for_a_delete_only_push"

    # tests/test_package_init_lazy.py: 1/13 disabled
    "test_dynamic_detector_import_skips_optional_ml_dependencies"

    # tests/test_proxy/test_cc_switch_reconciler.py: 3/16 disabled
    # Consecutive writes can share an mtime in the sandbox, so the change is not detected.
    "test_ipv6_proxy_address_is_self_only_for_ipv6_bind"
    "test_official_resets_a_captured_third_party_upstream"
    "test_switching_provider_recaptures"

    # tests/test_proxy_scalability.py: 1/18 disabled
    "test_run_server_uses_selector_loop_on_windows"

    # tests/test_stateless_no_disk.py: 1/14 disabled
    # CliRunner enters proxy dependency startup before observing the environment flag.
    "test_cli_stateless_flag_exports_env_for_children"

    # The following tests require Hugging Face models or datasets unavailable in the sandbox.

    # tests/test_evals/test_html_oss_benchmarks.py: 5/12 disabled
    "test_benchmark_loads"
    "test_compression_achieved"
    "test_extraction_f1_full"
    "test_extraction_f1_medium"
    "test_extraction_f1_quick"

    # tests/test_memory/test_embedder_thread_cap.py: 1/9 disabled
    "test_cpu_embed_workers_are_thread_capped"

    # tests/test_memory/test_embedder_mps_serialization.py: 1/4 disabled
    "test_cpu_uses_dedicated_thread_capped_executor"

    # tests/test_memory/test_hierarchical.py: 4/41 disabled
    # test_embed_batch also matches test_embed_batch_uses_batched_onnx_inference.
    "test_embed_batch"
    "test_embed_single"
    "test_similar_texts_have_high_similarity"

    # tests/test_memory_bridge.py: 1/40 disabled
    "test_import_export_preserves_facts"

    # tests/test_relevance.py: 4/34 disabled
    "test_batch_efficiency"
    "test_hybrid_scoring"
    "test_paraphrase_match"
    "test_semantic_match"

    # tests/gateway/test_compress_turn_seam.py: 1/9 disabled
    # The route is claimed by the generic proxy when the optional gateway contract is disabled.
    "test_contract_disabled_by_env"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # tests/test_cli/test_wrap_persistent.py: 4/62 disabled
    # These fixtures omit runtime_kind, causing persistent proxy recovery to fail on Darwin.
    "test_ensure_proxy_recovers_matching_persistent_deployment"
    "test_ensure_proxy_recovers_persistent_deployment_when_socket_is_bound"
    "test_recover_persistent_proxy_reuses_healthy_deployment"
    "test_recover_persistent_proxy_warns_for_task_deployment"

    # tests/test_content_router_ml_stage_deadline.py: 5/16 disabled
    # Sub-second timing assertions are flaky with Darwin sandbox scheduling latency.
    "test_a_slow_call_cannot_be_admitted_against_a_budget_it_will_overrun"
    "test_cold_remote_call_is_bounded_as_a_whole_by_the_ml_budget"
    "test_non_ml_prework_does_not_consume_the_ml_budget"
    "test_saturated_remote_calls_fail_open_without_queueing_their_payloads"
    "test_slow_drip_response_is_cut_off_at_an_absolute_deadline"

    # tests/test_content_router_single_item_deadline.py: 1/4 disabled
    # This test is also sensitive to Darwin sandbox scheduling latency.
    "test_single_cache_miss_deadline_starts_before_kompress_load"

    # tests/test_corporate_tls.py: 4/32 disabled
    # truststore's macOS certificate verification is unavailable in the sandbox (OSStatus -26276).
    "test_default_policy_plus_corporate_root_succeeds"
    "test_doctor_endpoint_probe_reports_vendor"
    "test_websocket_context_trusts_corporate_root"

    # tests/test_storage_backends.py: 1/15 disabled
    # Flaky on Darwin: sqlite3.OperationalError "attempt to write a readonly database".
    "test_create_storage_builtin_entrypoint_and_fallback"

    # tests/test_proxy_uds.py: 11/24 disabled
    # Darwin has a 104-byte UNIX socket path limit, which Nix's pytest temporary-directory paths exceed.
    "test_prepare_accepts_a_sticky_world_writable_parent"
    "test_prepare_clears_a_stale_socket"
    "test_prepare_creates_parent_owner_only"
    "test_prepare_never_deletes_a_regular_file"
    "test_prepare_only_chmods_directories_it_creates"
    "test_prepare_preserves_an_existing_parents_mode"
    "test_prepare_refuses_a_live_socket"
    "test_prepare_refuses_a_world_writable_existing_parent"
    "test_remove_uds_path_is_socket_only"
    "test_run_server_binds_the_socket_instead_of_a_port"
    "test_run_server_removes_the_socket_on_exit"
  ];

  disabledTestPaths = [
    # Setting the setuid bit (0o4600) is not permitted in the sandbox.
    "tests/test_private_state_files.py::TestEnsurePrivateFile::test_non_0600_mode_is_narrowed_once_then_skipped[2432]"
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      cryptography
      gitMinimal
      hnswlib
      langchain-ollama
      ollama
      pytest-asyncio
      pytest-cov-stub
      pytestCheckHook
      respx
      socksio
      unzip
      versionCheckHook
      xlwt
      writableTmpDirAsHomeHook
    ]
    ++ bundledTools;

  preCheck =
    # Fail fast for optional Hugging Face models, which cannot be downloaded in the test sandbox.
    ''
      export HF_HUB_OFFLINE=1
      export TRANSFORMERS_OFFLINE=1
    ''
    # Tiktoken lazily downloads its OpenAI encoding files. Use Nix-fetched copies in the test sandbox.
    + ''
      export TIKTOKEN_CACHE_DIR=${tiktokenEncodings}
    ''
    # The upstream health probe and SSRF guard cannot reach the mock upstream hosts in the test sandbox.
    + ''
      export HEADROOM_SKIP_UPSTREAM_CHECK=1
      export HEADROOM_ALLOWED_BASE_URLS=httpbin.org,api.deepseek.com,opencode.ai,api.githubcopilot.com
    ''
    # Use LiteLLM's bundled price map; the test sandbox has no network access.
    + ''
      export LITELLM_LOCAL_MODEL_COST_MAP=True
    ''
    # The source package is needed by tests that load files directly by path.
    # Extract only maturin's platform-specific native module from the wheel.
    + ''
      unzip -j "$dist"/*.whl 'headroom/_core.*' -d headroom
    '';

  meta = {
    description = "Context optimization layer for LLM applications";
    homepage = "https://github.com/headroomlabs-ai/headroom";
    changelog = "https://github.com/headroomlabs-ai/headroom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "headroom";
    maintainers = with lib.maintainers; [ attila ];
  };
})
