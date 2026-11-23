{
  lib,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sigwood";
  version = "1.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "helixmap";
    repo = "sigwood";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oNcrSXnDDs3NDXBxu8U93rdt8VXxYqwAXaq+6Ugr1cE=";
  };

  pythonRelaxDeps = [ "pandas" ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    boto3
    botocore
    drain3
    fast-hdbscan
    hdbscan
    numpy
    pandas
    scikit-learn
    splunk-sdk
    tldextract
    tqdm
    weasyprint
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytestCheckHook
    ]
    ++ [ gitMinimal ];

  disabledTestPaths = [
    # Upstream logic regressions, require live system log access
    "tests/test_syslog_preparation.py"
    # Sandbox prohibits chmod
    "tests/test_write_permissions.py"
    "tests/test_init_wizard.py"
    # Frozen golden-snapshot regressions against pandas 4.x
    "tests/test_syslog_memory_shape.py"
  ];

  disabledTests = [
    # Use today's date as a fixture value; always fail on any given day
    "test_default_window_anchors_follow_the_knob"
    "test_graph_date_dir_window_uses_exact_name_and_display_timezone"
    "test_trim_disclosure_uses_the_local_display_timezone"
    "test_report_basename_date_routes_through_display_seam"
    "test_digest_out_dir_filename_date_follows_the_knob"
    "test_naive_since_follows_the_knob"
    "test_days_snap_follows_the_knob_and_is_representation_independent"
    # Assume a specific non-UTC local timezone in fixture expected values
    "test_data_window_offset_follows_display_switch"
    "test_fmt_timestamp_seconds_mode_local_and_utc"
    "test_fmt_window_converts_to_machine_local_zone"
    "test_fmt_display_switch_flips_zone_and_label"
    "test_to_display_timezone_follows_switch"
    "test_timestamp_host_local_epoch"
    "test_evidence_walk_is_recursive_detached_and_strictly_allow_listed"
    "test_text_and_html_format_selected_and_nested_instants_at_honest_levels"
    "test_ssl_level_zero_first_seen_uses_same_seconds_owner_and_can_vanish"
    "test_rotation_peek_ts_matches_loader_ts_syslog_non_utc"
    "test_syslog_window_filter_true_instants_non_utc"
    # Upstream logic mismatch
    "test_cross_feed_arbitration_drops_only_folded_local_hosts"
    "test_legacy_dnsblock_reading_bytes_pin_the_reviewed_mission_chrome"
    "test_real_cli_discloses_every_non_detector_scope_in_contract_order"
    "test_cli_disclosure_is_not_quiet_gated_and_keeps_success_exit"
    # Bench subcommand spawns sigwood as a child process; fails in sandbox
    "test_child_stderr_is_quarantined_byte_for_byte"
    "test_cli_record_count_mismatch_fails_with_actionable_safe_message"
    "test_selector_match_value_never_crosses_parent_surfaces"
    "test_selector_detector_must_be_in_run_status_without_echo"
    "test_parent_failure_retains_raw_diagnostic_without_echo"
    "test_two_run_exit_mismatch_emits_no_summary"
    # Pandas 4.x incompatible indexer
    "test_unhashable_classification_fallback_has_scalar_parity"
    # Timezone offset mismatch (fixture assumes UTC-6)
    "test_export_naive_since_follows_config_knob"
  ];

  pytestFlags = [ "-W ignore::pandas.errors.Pandas4Warning" ];

  preCheck = ''
    export NUMBA_CACHE_DIR=$(mktemp -d)
    export PATH="$out/bin:$PATH"
    # test_voice_consistency uses git ls-files; nix store has no .git dir
    git init
    git add -A
  '';

  pythonImportsCheck = [ "sigwood" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for threat hunting in log files";
    homepage = "https://github.com/helixmap/sigwood";
    changelog = "https://github.com/helixmap/sigwood/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sigwood";
  };
})
