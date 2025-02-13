{
  fetchFromGitHub,
  file,
  lib,
  pkg-config,
  rustPlatform,
  sqlite,
  stdenv,
  zstd,
}:

let
  pname = "qsv";
  version = "0.138.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "jqnatividad";
    repo = "qsv";
    rev = version;
    hash = "sha256-27oSk8fnTvl1zJ8xYkZHkWVTq+AVDn4Zi1s56T49T1Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tu9HCFAxmmYVgmJyHunBtGSqKGzwbX2vi6ju4cv33wc=";

  buildInputs = [
    file
    sqlite
    zstd
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildFeatures = [
    "apply"
    "feature_capable"
    "fetch"
    "foreach"
    "geocode"
    "to"
  ];

  checkFeatures = [
    "apply"
    "feature_capable"
    "fetch"
    "foreach"
    "geocode"
  ];

  checkFlags =
    [
      # Skip tests that require network access.
      "--skip test_fetch"
      "--skip test_geocode"
      "--skip cmd::validate::test_load_json_via_url"
      "--skip cmd::validate::test_dyn_enum_validator"
      "--skip cmd::validate::test_validate_currency_email_dynamicenum_validator"
      "--skip test_describegpt::describegpt_invalid_api_key"
      "--skip test_sample::sample_seed_url"
      "--skip test_snappy::snappy_decompress_url"
      "--skip test_sniff::sniff_justmime_remote"
      "--skip test_sniff::sniff_url_notcsv"
      "--skip test_sniff::sniff_url_snappy"
      "--skip test_sniff::sniff_url_snappy_noinfer"
      "--skip test_validate::validate_adur_public_toilets_dataset_with_json_schema_url"
      "--skip test_schema::generate_schema_with_const_and_enum_constraints"
      "--skip test_schema::generate_schema_with_defaults_and_validate_trim_with_no_errors"
      "--skip test_schema::generate_schema_with_optional_flags_notrim_and_validate_with_errors"
      "--skip test_schema::generate_schema_with_optional_flags_trim_and_validate_with_errors"
      "--skip test_validate::validate_adur_public_toilets_dataset_with_json_schema"
      "--skip test_validate::validate_adur_public_toilets_dataset_with_json_schema_valid_output"
      # Skip test that uses sh.
      "--skip test_foreach::foreach_multiple_commands_with_shell_script"
      # Skip features that aren't enabled.
      "--skip test_luau"
      # Skip tests that return the wrong datetime in CI.
      "--skip test_stats::stats_cache_negative_threshold"
      "--skip test_stats::stats_cache_negative_threshold_five"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # uses X11 based clipboard library
      "--skip test_clipboard::clipboard_success"
    ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "CSVs sliced, diced & analyzed";
    homepage = "https://github.com/jqnatividad/qsv";
    changelog = "https://github.com/jqnatividad/qsv/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      # or
      unlicense
    ];
    maintainers = with lib.maintainers; [
      detroyejr
      uncenter
    ];
  };
}
