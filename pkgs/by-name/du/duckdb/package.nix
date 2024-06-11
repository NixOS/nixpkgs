{ lib
, stdenv
, fetchFromGitHub
, git
, cmake
, ninja
, openssl
, python3
, unixODBC
, withOdbc ? false
}:

let
  canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  # needs to match source/src/include/duckdb/common/platform.h
  duckDBPlatform = let
    os = if stdenv.hostPlatform.parsed.kernel.name == "darwin"
      then "osx"
      else stdenv.hostPlatform.parsed.kernel.name;
    arch = {
      "aarch64" = "arm64";
      "x86_64" = "amd64";
    }.${stdenv.hostPlatform.parsed.cpu.name} or stdenv.hostPlatform.parsed.cpu.name;
  in
    "${os}_${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "duckdb";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "duckdb";
    repo = "duckdb";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-6pP0MZs4IClszNcLTN+nkcuKml1rIG4FY/ybRV6nINU=";

    # pull the git revision from the tar file and store it in .git/HEAD
    nativeBuildInputs = [ git ];
    # Ignore broken pipe error from gzip as git get-tar-common-id exits after
    # reading 1k from the input stream.
    postFetch = ''
      mkdir "$out"/.git
      (gzip -cd "$renamed" 2>/dev/null || true) | \
        git get-tar-commit-id > "$out"/.git/HEAD
    '';
  };

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ cmake ninja python3 ];
  buildInputs = [ openssl ]
    ++ lib.optionals withOdbc [ unixODBC ];

  cmakeFlags = [
    "-DDUCKDB_EXTENSION_CONFIGS=.github/config/in_tree_extensions.cmake"
    (lib.cmakeBool "BUILD_ODBC_DRIVER" withOdbc)
    (lib.cmakeBool "BUILD_UNITTESTS" finalAttrs.doInstallCheck)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinMinVersion}"
  ]
  ++ lib.optionals (!canExecute) [
    "-DDUCKDB_EXPLICIT_PLATFORM=${duckDBPlatform}"
  ];

  preConfigure = ''
    cmakeFlagsArray+=( "-DINSTALL_BIN_DIR=$out/bin" )
    cmakeFlagsArray+=( "-DINSTALL_INCLUDE_DIR=$dev/include" )
    cmakeFlagsArray+=( "-DINSTALL_LIB_DIR=$lib/lib" )
    cmakeFlagsArray+=( "-DOVERRIDE_GIT_DESCRIBE=v${finalAttrs.version}-0-g$(< .git/HEAD)" )
  '';

  postBuild = ''
    if [[ $(< duckdb_platform_out) != "${duckDBPlatform}" ]]; then
      echo "error: $(< duckdb_platform_out) != ${duckDBPlatform}" >&2
      exit 1
    fi
  '';

  doInstallCheck = canExecute;

  installCheckPhase =
    let
      excludes = map (pattern: "exclude:'${pattern}'") ([
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
      ] ++ lib.optionals stdenv.isAarch64 [
        "test/sql/aggregate/aggregates/test_kurtosis.test"
        "test/sql/aggregate/aggregates/test_skewness.test"
        "test/sql/function/list/aggregates/skewness.test"
      ]);
      LD_LIBRARY_PATH = lib.optionalString stdenv.isDarwin "DY" + "LD_LIBRARY_PATH";
    in
    ''
      runHook preInstallCheck
      (($(ulimit -n) < 1024)) && ulimit -n 1024

      HOME="$(mktemp -d)" ${LD_LIBRARY_PATH}="$lib/lib" ./test/unittest ${toString excludes}

      runHook postInstallCheck
    '';

  meta = with lib; {
    changelog = "https://github.com/duckdb/duckdb/releases/tag/v${finalAttrs.version}";
    description = "Embeddable SQL OLAP Database Management System";
    homepage = "https://duckdb.org/";
    license = licenses.mit;
    mainProgram = "duckdb";
    maintainers = with maintainers; [ costrouc cpcloud paparodeo ];
    platforms = platforms.all;
  };
})
