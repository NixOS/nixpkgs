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
  git,
  writableTmpDirAsHomeHook,
}:

let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      mcp = final.mcp_1;
    }
  );

  dependencies = with pythonPackages; [
    ast-grep-cli
    anthropic
    click
    datasets
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
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "headroom";
  version = "0.41.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "headroomlabs-ai";
    repo = "headroom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ITVrw5ruGnNI9t7pq+0Z6gsnqDDAB/5v7I3oOQM5AtE=";
  };

  patches = [
    ./restore-cli-main-before-offline-check.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    ./preserve-sandbox-proxy-environment.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-RF1b24TIV3EASGfXKUHSrGgQGBUmJLYxzDEjb4fvKPo=";
  };

  build-system = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  inherit dependencies;

  makeWrapperArgs = [
    # Preserve PYTHONPATH because proxy startup re-execs `python -m headroom.cli`.
    "--prefix"
    "PYTHONPATH"
    ":"
    "${placeholder "out"}/${python3.sitePackages}:${pythonPackages.makePythonPath dependencies}"

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

  disabledTests = [
    # These tests cover service/process management or platform behavior untestable in the test sandbox.
    "test_bash_native_installer_supports_persistent_docker_lifecycle"
    "test_bash_native_wrapper_supports_opencode"
    "test_device_authorization_uses_form_encoded_request"
    "test_device_poll_uses_form_encoded_request"
    "test_dynamic_detector_import_skips_optional_ml_dependencies"
    "test_ensure_proxy_dependencies_exits_when_fastapi_missing"
    "test_exchange_token_sync_raises_for_http_error"
    "test_install_supervisor_darwin_windows_and_unsupported"
    "test_ordinary_install_does_not_adopt_serena"
    "test_proxy_command_exits_when_mcp_missing"
    "test_quiesce_turns_config_is_honored"
    "test_readyz_excludes_kompress_from_aggregate_readiness"
    "test_readyz_keeps_pending_kompress_unloaded"
    "test_readyz_kompress_state_matrix"
    "test_readyz_never_calls_lazy_kompress_getters"
    "test_replayed_marker_is_not_rebooked_in_the_emitted_savings"
    "test_run_server_uses_selector_loop_on_windows"
    "test_runtime_start_lock_blocks_another_process"
    # These subprocess tests replace the test environment, losing Nix's
    # PYTHONPATH, so the child cannot import the in-tree package under test.
    "test_healthy_process_is_never_shot"
    "test_seized_gil_is_dumped_and_exited"
    "test_swapped_stderr_does_not_kill_the_heartbeat"
    # CliRunner enters full proxy dependency startup before observing this process-environment flag.
    "test_cli_stateless_flag_exports_env_for_children"
    # These tests download a SentenceTransformer model from Hugging Face, which is unavailable in the sandbox.
    "test_cpu_embed_workers_are_thread_capped"
    "test_cpu_uses_dedicated_thread_capped_executor"
    "test_embed_batch"
    "test_embed_single"
    "test_similar_texts_have_high_similarity"
    # These tests require Hugging Face datasets or models not bundled with the package.
    "test_batch_efficiency"
    "test_benchmark_loads"
    "test_compression_achieved"
    "test_extraction_f1_full"
    "test_extraction_f1_medium"
    "test_extraction_f1_quick"
    "test_hybrid_scoring"
    "test_import_export_preserves_facts"
    "test_paraphrase_match"
    "test_semantic_match"
    # The route is claimed by the generic proxy when the optional gateway contract is disabled.
    "test_contract_disabled_by_env"
    # Nix creates tmp_path below /build, which the watcher treats as an ignored directory.
    # Its main.py event never reaches _schedule_reindex(), so `scheduled == [\"reindex\"]` fails.
    "test_code_graph_watcher_init_start_stop_and_event_filtering"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # These tests assert sub-second wall-clock limits around sleeping threads
    # and mocked HTTP responses. Darwin's scheduling latency in the Nix sandbox
    # makes them flaky without exercising a platform-specific code path.
    "test_non_ml_prework_does_not_consume_the_ml_budget"
    "test_cold_remote_call_is_bounded_as_a_whole_by_the_ml_budget"
    "test_saturated_remote_calls_fail_open_without_queueing_their_payloads"
    "test_slow_drip_response_is_cut_off_at_an_absolute_deadline"
    "test_single_cache_miss_deadline_starts_before_kompress_load"
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
    # These fixtures omit runtime_kind, causing persistent proxy recovery to fail on Darwin.
    "test_ensure_proxy_recovers_matching_persistent_deployment"
    "test_ensure_proxy_recovers_persistent_deployment_when_socket_is_bound"
    "test_recover_persistent_proxy_reuses_healthy_deployment"
    "test_recover_persistent_proxy_warns_for_task_deployment"
  ];

  # LiteLLM 1.81.12 does not contain this upstream test's expected Groq model price.
  pytestFlags = [
    "--deselect=tests/test_pricing_from_litellm.py::test_provider_prices_models_its_table_never_covered[groq/llama-guard-3-8b-0.2-0.2]"
  ];

  nativeCheckInputs =
    with pythonPackages;
    [
      cryptography
      git
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

  versionCheckProgram = "${placeholder "out"}/bin/headroom";

  preCheck = ''
    # Fail fast for optional Hugging Face models, which cannot be downloaded in the test sandbox.
    export HF_HUB_OFFLINE=1
    export TRANSFORMERS_OFFLINE=1

    # Tiktoken lazily downloads its OpenAI encoding files. Use Nix-fetched copies in the test sandbox.
    export TIKTOKEN_CACHE_DIR=${tiktokenEncodings}

    # The upstream health probe and SSRF guard cannot reach the mock upstream hosts in the test sandbox.
    export HEADROOM_SKIP_UPSTREAM_CHECK=1
    export HEADROOM_ALLOWED_BASE_URLS=httpbin.org,api.deepseek.com,opencode.ai,api.githubcopilot.com

    # Use LiteLLM's bundled price map; the test sandbox has no network access.
    export LITELLM_LOCAL_MODEL_COST_MAP=True

    # The source package is needed by tests that load files directly by path.
    # Extract only maturin's platform-specific native module from the wheel.
    unzip -j "$dist"/*.whl 'headroom/_core.*' -d headroom
  '';

  meta = {
    description = "Context optimization layer for LLM applications";
    homepage = "https://github.com/headroomlabs-ai/headroom";
    license = lib.licenses.asl20;
    mainProgram = "headroom";
    maintainers = with lib.maintainers; [ attila ];
  };
})
