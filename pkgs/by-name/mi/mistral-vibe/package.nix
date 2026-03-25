{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,

  # tests
  uv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mistral-vibe";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-vibe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5su0Qfg3M+Yq4pkptDOJhvM8VFGCaOLeeDijeFeywP4=";
  };

  build-system = with python3Packages; [
    editables
    hatch-vcs
    hatchling
  ];

  pythonRelaxDeps = [
    "agent-client-protocol"
    "cryptography"
    "gitpython"
    "mistralai"
    "pydantic-settings"
    "zstandard"
  ];
  dependencies = with python3Packages; [
    agent-client-protocol
    anyio
    cachetools
    cryptography
    gitpython
    giturlparse
    google-auth
    httpx
    keyring
    mcp
    markdownify
    mistralai
    packaging
    pexpect
    pydantic
    pydantic-settings
    pyperclip
    python-dotenv
    pyyaml
    requests
    rich
    sounddevice
    textual
    textual-speedups
    tomli-w
    tree-sitter
    tree-sitter-bash
    watchfiles
    websockets
    zstandard
  ];

  pythonImportsCheck = [ "vibe" ];

  nativeCheckInputs = [
    python3Packages.pytest-asyncio
    python3Packages.pytest-textual-snapshot
    python3Packages.pytest-xdist
    python3Packages.pytestCheckHook
    python3Packages.respx
    uv
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  disabledTests = [
    # Fail in the sandbox
    # vibe.core.audio_recorder.audio_recorder_port.NoAudioInputDeviceError: No audio input device available
    "test_audio_stream_yields_chunks"
    "test_auto_stops_after_max_duration"
    "test_buffer_mode_audio_stream_yields_nothing"
    "test_can_record_multiple_times"
    "test_cancel_discards_audio"
    "test_manual_stop_prevents_on_expire"
    "test_on_expire_receives_audio"
    "test_peak_clamps_to_one"
    "test_peak_updates_from_callback"
    "test_silent_audio_has_zero_peak"
    "test_start_sets_recording_state"
    "test_start_when_already_recording_raises"
    "test_stop_from_event_loop_does_not_block"
    "test_stop_returns_empty_data_in_stream_mode"
    "test_stop_returns_positive_duration"
    "test_stop_returns_valid_wav"
    "test_stop_without_drain_returns_promptly"
    "test_stream_audio_does_not_leak_into_buffer_recording"
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
    # All snapshot tests fail with AssertionError
    "tests/snapshots/"

    # Try to invoke `uv run vibe`
    "tests/e2e/"

    # ACP tests require network access
    "tests/acp/test_acp.py"
  ];

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
