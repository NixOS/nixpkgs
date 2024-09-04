{
  darwin,
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
  version = "0.131.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "jqnatividad";
    repo = "qsv";
    rev = version;
    hash = "sha256-erXMDZBkOPnZdhhjnUTiS0eCuFo1v5sNhLn8o7QN/5g=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "calamine-0.25.0" = "sha256-LFQahQ+SfGWhp5Kfs7AJCj4zyxWiz099pwVuQucCF00=";
      "dynfmt-0.1.5" = "sha256-/SrNOOQJW3XFZOPL/mzdOBppVCaJNNyGBuJumQGx6sA=";
      "grex-1.4.5" = "sha256-4Tr5L87HuiUW8tJdqr4oT1yQXviU7XtDrKY7iYNcwbo=";
      "local-encoding-0.2.0" = "sha256-ThXYKr3u/n2kvINcyobB2Ayex2sNbJEOyyjZH993Z4U=";
      "polars-0.41.3" = "sha256-8xkcJgfKo7BzeBnR6XVdbcH9ZY9Kh4dcGFMmyA5LuQg=";
    };
  };

  buildInputs =
    [
      file
      sqlite
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AppKit
        CoreFoundation
        CoreGraphics
        IOKit
        Security
        SystemConfiguration
      ]
    );

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

  checkFlags = [
    # Skip tests that require network access.
    "--skip test_fetch"
    "--skip test_geocode"
    "--skip cmd::validate::test_load_json_via_url"
    "--skip test_describegpt::describegpt_invalid_api_key"
    "--skip test_sample::sample_seed_url"
    "--skip test_snappy::snappy_decompress_url"
    "--skip test_sniff::sniff_justmime_remote"
    "--skip test_sniff::sniff_url_notcsv"
    "--skip test_sniff::sniff_url_snappy"
    "--skip test_sniff::sniff_url_snappy_noinfer"
    "--skip test_validate::validate_adur_public_toilets_dataset_with_json_schema_url"
    # Skip test that uses sh.
    "--skip test_foreach::foreach_multiple_commands_with_shell_script"
    # Skip features that aren't enabled.
    "--skip test_luau"
    # Skip tests that return the wrong datetime in CI.
    "--skip test_stats::stats_cache_negative_threshold"
    "--skip test_stats::stats_cache_negative_threshold_five"
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
