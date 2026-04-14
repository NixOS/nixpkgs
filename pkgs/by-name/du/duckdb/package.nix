{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  openssl,
  openjdk11,
  python3,
  unixodbc,
  withJdbc ? false,
  withOdbc ? false,
  versionCheckHook,
}:

let
  versions = lib.importJSON ./versions.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "duckdb";
  inherit (versions) rev version;

  src = fetchFromGitHub {
    # to update run:
    # nix-shell maintainers/scripts/update.nix --argstr path duckdb
    inherit (versions) hash;
    owner = "duckdb";
    repo = "duckdb";
    tag = "v${finalAttrs.version}";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals withJdbc [ openjdk11 ]
  ++ lib.optionals withOdbc [ unixodbc ];

  cmakeFlags = [
    (lib.cmakeFeature "DUCKDB_EXTENSION_CONFIGS" "${finalAttrs.src}/.github/config/in_tree_extensions.cmake")
    (lib.cmakeBool "BUILD_ODBC_DRIVER" withOdbc)
    (lib.cmakeBool "JDBC_DRIVER" withJdbc)
    (lib.cmakeFeature "OVERRIDE_GIT_DESCRIBE" "v${finalAttrs.version}-0-g${finalAttrs.rev}")
    # development settings
    (lib.cmakeBool "BUILD_UNITTESTS" finalAttrs.doInstallCheck)
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  installCheckPhase =
    let
      excludes = map (pattern: "exclude:'${pattern}'") (
        [
          "[s3]"
          "Test closing database during long running query"
          "Test using a remote optimizer pass in case thats important to someone"
          "test/common/test_cast_hugeint.test"
          "test/sql/copy/csv/test_csv_remote.test"
          "test/sql/copy/parquet/test_parquet_remote.test"
          "test/sql/copy/parquet/test_parquet_remote_foreign_files.test"
          "test/sql/storage/compression/chimp/chimp_read.test"
          "test/sql/storage/compression/chimp/chimp_read_float.test"
          "test/sql/storage/compression/patas/patas_compression_ratio.test_coverage"
          "test/sql/storage/compression/patas/patas_read.test"
          "test/sql/json/read_json_objects.test"
          "test/sql/json/read_json.test"
          "test/sql/json/table/read_json_objects.test"
          "test/sql/json/table/read_json.test"
          "test/sql/copy/parquet/parquet_5968.test"
          "test/fuzzer/pedro/buffer_manager_out_of_memory.test"
          "test/sql/storage/compression/bitpacking/bitpacking_size_calculation.test"
          "test/sql/copy/parquet/delta_byte_array_length_mismatch.test"
          "test/sql/function/timestamp/test_icu_strptime.test"
          "test/sql/timezone/test_icu_timezone.test"
          "test/sql/copy/parquet/snowflake_lineitem.test"
          "test/sql/copy/parquet/test_parquet_force_download.test"
          "test/sql/copy/parquet/delta_byte_array_multiple_pages.test"
          "test/sql/copy/csv/test_csv_httpfs_prepared.test"
          "test/sql/copy/csv/test_csv_httpfs.test"
          "test/sql/settings/test_disabled_file_system_httpfs.test"
          "test/sql/copy/csv/parallel/test_parallel_csv.test"
          "test/sql/copy/csv/parallel/csv_parallel_httpfs.test"
          "test/common/test_cast_struct.test"
          # test is order sensitive
          "test/sql/copy/parquet/parquet_glob.test"
          # these are only hidden if no filters are passed in
          "[!hide]"
          # this test apparently never terminates
          "test/sql/copy/csv/auto/test_csv_auto.test"
          # test expects installed file timestamp to be > 2024
          "test/sql/table_function/read_text_and_blob.test"
          # fails with Out of Memory Error
          "test/sql/copy/parquet/batched_write/batch_memory_usage.test"
          # wants http connection
          "test/sql/copy/csv/recursive_query_csv.test"
          "test/sql/copy/csv/test_mixed_lines.test"
          "test/parquet/parquet_long_string_stats.test"
          "test/sql/attach/attach_remote.test"
          "test/sql/copy/csv/test_sniff_httpfs.test"
          "test/sql/httpfs/internal_issue_2490.test"
          # fails with incorrect result
          # Upstream issue https://github.com/duckdb/duckdb/issues/14294
          "test/sql/copy/file_size_bytes.test"
          # https://github.com/duckdb/duckdb/issues/17757#issuecomment-3032080432
          "test/issues/general/test_17757.test"
        ]
        ++ lib.optionals stdenv.hostPlatform.isAarch64 [
          "test/sql/aggregate/aggregates/test_kurtosis.test"
          "test/sql/aggregate/aggregates/test_skewness.test"
          "test/sql/function/list/aggregates/skewness.test"
          "test/sql/aggregate/aggregates/histogram_table_function.test"
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          # UB in PhysicalRangeJoin (shared by IEJoin and PiecewiseMergeJoin) causes
          # Apple Clang at -O3 to emit brk trap instructions on aarch64-darwin.
          # Affects any test routing through PhysicalIEJoin (2+ inequality conditions,
          # cardinality >= merge_join_threshold) or forcing IEJoin via debug_asof_iejoin.
          "test/sql/join/iejoin/iejoin_issue_6314.test_slow"
          "test/sql/join/iejoin/iejoin_issue_6861.test"
          "test/sql/join/iejoin/iejoin_issue_7278.test"
          "test/sql/join/iejoin/iejoin_projection_maps.test"
          "test/sql/join/iejoin/merge_join_switch.test"
          "test/sql/join/iejoin/predicate_expressions.test"
          "test/sql/join/iejoin/test_countzeros.test"
          "test/sql/join/iejoin/test_ieantijoin.test"
          "test/sql/join/iejoin/test_iejoin.test"
          "test/sql/join/iejoin/test_iejoin_east_west.test"
          "test/sql/join/iejoin/test_iejoin_events.test"
          "test/sql/join/iejoin/test_iejoin_null_keys.test"
          "test/sql/join/iejoin/test_iejoin_overlaps.test"
          "test/sql/join/iejoin/test_iejoin_predicate.test"
          "test/sql/join/iejoin/test_iejoin_sort_tasks.test_slow"
          "test/sql/join/iejoin/test_iesemijoin.test"
          # asof tests that loop debug_asof_iejoin=True, forcing the IEJoin path
          "test/sql/join/asof/test_asof_join_inequalities.test"
          "test/sql/join/asof/test_asof_join_missing.test_slow"
          # 10240-row inequality join routing to IEJoin via plan_comparison_join.cpp
          "test/sql/join/test_complex_range_join.test"
        ]
      );
      LD_LIBRARY_PATH = lib.optionalString stdenv.hostPlatform.isDarwin "DY" + "LD_LIBRARY_PATH";
    in
    ''
      runHook preInstallCheck
      (($(ulimit -n) < 1024)) && ulimit -n 1024

      HOME="$(mktemp -d)" ${LD_LIBRARY_PATH}="$lib/lib" ./test/unittest ${toString excludes}

      runHook postInstallCheck
    '';

  passthru.updateScript = ./update.sh;
  passthru.pythonHash = versions.python_hash;

  meta = {
    changelog = "https://github.com/duckdb/duckdb/releases/tag/v${finalAttrs.version}";
    description = "Embeddable SQL OLAP Database Management System";
    homepage = "https://duckdb.org/";
    license = lib.licenses.mit;
    mainProgram = "duckdb";
    maintainers = with lib.maintainers; [
      cameronraysmith
      costrouc
      cpcloud
    ];
    platforms = lib.platforms.all;
  };
})
