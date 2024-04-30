{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, sqlite
, zstd
, stdenv
, darwin
, python3
, file
}:

rustPlatform.buildRustPackage rec {
  pname = "qsv";
  version = "0.125.0";

  src = fetchFromGitHub {
    owner = "jqnatividad";
    repo = "qsv";
    rev = version;
    hash = "sha256-y3u0NH5pJ3n+ixB9MkpyfMSFK2AiT1h667mmEH/Gw+w=";
  };

  patchPhase = ''
    substitute "$src/tests/tests.rs" "./tests/tests.rs" \
      --replace-warn \
      "#[derive(Clone, Eq, Ord, PartialEq, PartialOrd)]" \
      "#[derive(Debug, Clone, Eq, Ord, PartialEq, PartialOrd)]"
  '';
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dynfmt-0.1.5" = "sha256-/SrNOOQJW3XFZOPL/mzdOBppVCaJNNyGBuJumQGx6sA=";
      "grex-1.4.5" = "sha256-hMUEA4ED7JJVJJpwDAzhwn8nDYC3UnvBu182EGY0KuM=";
      "cached-0.49.2" = "sha256-go87UJpMfvb9f/kbBIU4N56Az/De8W6jX/B8KuOzYUM=";
      "jsonschema-0.17.1" = "sha256-Jm1D4PVyNPsG2o1gUrahmCGnKlV0iGPa51F0P5D1Ovw=";
      "self_update-0.39.0" = "sha256-RPbhSYsXTG4fL5+jrzEMGJyUTtWs1cMsPYgvk/LA0Nk=";
      "localzone-0.2.0" = "sha256-J7I4XgoPpCZb8TTpq9ArsSpVRRAOkvdsZObRxRQqKhM=";
    };
  };

  buildInputs =
    [
      sqlite
      zstd
      file
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.SystemConfiguration
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Security
    ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    python3
  ];

  buildNoDefaultFeatures = true;

  buildFeatures = if !stdenv.isDarwin then [ "all_features" ] else [
    "feature_capable"
    "apply"
    "fetch"
    "foreach"
    "geocode"
    "to"
    "polars"
    "python"
    "self_update"
  ];

  checkFlags = [
    "--skip cmd::validate::test_load_json_via_url"
    "--skip test_describegpt::describegpt_invalid_api_key"
    "--skip test_fetch::fetch_custom_header"
    "--skip test_fetch::fetch_custom_user_agent"
    "--skip test_fetch::fetch_jql_multiple"
    "--skip test_fetch::fetch_jql_multiple_file"
    "--skip test_fetch::fetch_jql_single"
    "--skip test_fetch::fetch_jql_single_file"
    "--skip test_fetch::fetch_simple"
    "--skip test_fetch::fetch_simple_diskcache"
    "--skip test_fetch::fetch_simple_new_col"
    "--skip test_fetch::fetch_simple_url_template"
    "--skip test_fetch::fetch_user_agent"
    "--skip test_fetch::fetchpost_custom_user_agent"
    "--skip test_fetch::fetchpost_literalurl_test"
    "--skip test_fetch::fetchpost_simple_diskcache"
    "--skip test_fetch::fetchpost_simple_test"
    "--skip test_foreach::foreach_multiple_commands_with_shell_script"
    "--skip test_geocode::geocode_countryinfo"
    "--skip test_geocode::geocode_countryinfo_formatstr"
    "--skip test_geocode::geocode_countryinfo_formatstr_pretty_json"
    "--skip test_geocode::geocode_countryinfonow"
    "--skip test_geocode::geocode_countryinfonow_formatstr"
    "--skip test_geocode::geocode_countryinfonow_formatstr_pretty_json"
    "--skip test_geocode::geocode_reverse"
    "--skip test_geocode::geocode_reverse_dyncols_fmt"
    "--skip test_geocode::geocode_reverse_fmtstring"
    "--skip test_geocode::geocode_reverse_fmtstring_intl"
    "--skip test_geocode::geocode_reverse_fmtstring_intl_dynfmt"
    "--skip test_geocode::geocode_reverse_fmtstring_intl_invalid_dynfmt"
    "--skip test_geocode::geocode_reversenow"
    "--skip test_geocode::geocode_suggest"
    "--skip test_geocode::geocode_suggest_dyncols_fmt"
    "--skip test_geocode::geocode_suggest_dynfmt"
    "--skip test_geocode::geocode_suggest_filter_country_admin1"
    "--skip test_geocode::geocode_suggest_fmt"
    "--skip test_geocode::geocode_suggest_fmt_cityrecord"
    "--skip test_geocode::geocode_suggest_fmt_json"
    "--skip test_geocode::geocode_suggest_intl"
    "--skip test_geocode::geocode_suggest_intl_admin1_filter_country_inferencing"
    "--skip test_geocode::geocode_suggest_intl_country_filter"
    "--skip test_geocode::geocode_suggest_intl_multi_country_filter"
    "--skip test_geocode::geocode_suggest_invalid"
    "--skip test_geocode::geocode_suggest_invalid_dynfmt"
    "--skip test_geocode::geocode_suggest_pretty_json"
    "--skip test_geocode::geocode_suggestnow"
    "--skip test_geocode::geocode_suggestnow_default"
    "--skip test_geocode::geocode_suggestnow_formatstr_dyncols"
    "--skip test_luau::luau_register_lookup_table"
    "--skip test_luau::luau_register_lookup_table_on_dathere_url"
    "--skip test_luau::luau_register_lookup_table_on_url"
    "--skip test_sample::sample_seed_url"
    "--skip test_snappy::snappy_decompress_url"
    "--skip test_sniff::sniff_justmime_remote"
    "--skip test_sniff::sniff_url_notcsv"
    "--skip test_sniff::sniff_url_snappy"
    "--skip test_sniff::sniff_url_snappy_noinfer"
    "--skip test_to::to_parquet_dir"
    "--skip test_validate::validate_adur_public_toilets_dataset_with_json_schema_url"
  ];

  env = { ZSTD_SYS_USE_PKG_CONFIG = true; };

  meta = with lib; {
    description = "CSVs sliced, diced & analyzed";
    homepage = "https://github.com/jqnatividad/qsv";
    changelog = "https://github.com/jqnatividad/qsv/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ detroyejr ];
  };
}
