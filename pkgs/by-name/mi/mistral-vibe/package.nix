{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,

  # tests
  uv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  python = python3.override {
    packageOverrides = _final: prev: {
      # Many tests fail with the current version of opentelemetry we have in nixpkgs
      # vibe.acp.exceptions.InternalError: module '...' has no attribute 'GEN_AI_PROVIDER_NAME'
      opentelemetry-api = prev.opentelemetry-api.overridePythonAttrs (old: rec {
        version = "1.40.0";
        src = old.src.override {
          tag = "v${version}";
          hash = "sha256-1KVy9s+zjlB4w7E45PMCWRxPus24bgBmmM3k2R9d+Jg=";
        };
      });
      opentelemetry-exporter-otlp-proto-http =
        prev.opentelemetry-exporter-otlp-proto-http.overridePythonAttrs
          (old: {
            disabledTests =
              (old.disabledTests or [ ])
              ++ lib.optionals stdenv.hostPlatform.isDarwin [
                # AssertionError: False is not true
                # self.assertTrue(0.75 < after - before < 1.25)
                "test_retry_timeout"
              ];
          });
    };
  };
  python3Packages = python.pkgs;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mistral-vibe";
  version = "2.16.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-vibe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sv0gaEA7dvf4trxlsRQS9xA5Hiike5i/aLI3qYKP/lY=";
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
    # vibe.core.llm.exceptions.BackendError: LLM backend error [mock-provider]
    # reason: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: Missing Authority Key Identifier (_ssl.c:1032)
    "test_generic_backend_streaming_uses_ssl_cert_file"

    # AssertionError: assert 0 == 1
    "test_preserves_accents_when_matching_latin1_encoded_file"

    # Fail in the sandbox
    # vibe.core.audio_recorder.audio_recorder_port.NoAudioInputDeviceError: No audio input device available
    "test_audio_stream_yields_chunks"
    "test_auto_stops_after_max_duration"
    "test_buffer_mode_audio_stream_yields_nothing"
    "test_callback_feeds_audio_data"
    "test_callback_pads_silence_at_end"
    "test_can_play_multiple_times"
    "test_can_record_multiple_times"
    "test_cancel_discards_audio"
    "test_creates_stream_with_correct_params"
    "test_finished_callback_resets_state"
    "test_manual_stop_prevents_on_expire"
    "test_on_expire_receives_audio"
    "test_on_finished_called_after_natural_completion"
    "test_peak_clamps_to_one"
    "test_peak_updates_from_callback"
    "test_play_sets_playing_state"
    "test_play_when_already_playing_raises"
    "test_silent_audio_has_zero_peak"
    "test_start_sets_recording_state"
    "test_start_when_already_recording_raises"
    "test_stop_closes_stream"
    "test_stop_from_event_loop_does_not_block"
    "test_stop_returns_empty_data_in_stream_mode"
    "test_stop_returns_positive_duration"
    "test_stop_returns_valid_wav"
    "test_stop_triggers_on_finished_via_callback"
    "test_stop_without_drain_returns_promptly"
    "test_stream_audio_does_not_leak_into_buffer_recording"
    "test_unsupported_format_raises"

    # AssertionError: assert True is False
    #  +  where True = VibeApp(title='VibeApp', ...)._rewind_mode
    "test_rewind_confirm_edits_message_and_prefills_input"
    "test_rewind_option_selection_with_number_keys"

    # AssertionError: assert 3 == 1
    # +  where 3 = len([UserMessage(classes='user-message'), UserMessage(classes='...
    "test_rewind_removes_messages_after_selected"
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

    # Try to invoke `uv run vibe`
    "tests/e2e/"

    # ACP tests require network access
    "tests/acp/test_acp.py"
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
