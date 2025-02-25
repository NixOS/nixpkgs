{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "datafusion-cli";
  version = "45.0.0";

  src = fetchFromGitHub {
    name = "datafusion-cli-source";
    owner = "apache";
    repo = "arrow-datafusion";
    rev = version;
    sha256 = "sha256-XIxUp4i68psNtKoFR/uVJHCToz681m2q8qUhtMQKCLo=";
  };

  sourceRoot = "${src.name}/datafusion-cli";

  useFetchCargoVendor = true;
  cargoHash = "sha256-qJjZ4Um2K27IJy7w99kJGs5ZB1y57xd6P896+Hm2GOg=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # Some tests not found fake path
    "--skip=catalog::tests::query_gs_location_test"
    "--skip=catalog::tests::query_http_location_test"
    "--skip=catalog::tests::query_s3_location_test"
    "--skip=exec::tests::copy_to_external_object_store_test"
    "--skip=exec::tests::copy_to_object_store_table_s3"
    "--skip=exec::tests::create_object_store_table_cos"
    "--skip=exec::tests::create_object_store_table_http"
    "--skip=exec::tests::create_object_store_table_oss"
    "--skip=exec::tests::create_object_store_table_s3"
    "--skip=tests::test_parquet_metadata_works_with_strings"
  ];

  meta = with lib; {
    description = "cli for Apache Arrow DataFusion";
    mainProgram = "datafusion-cli";
    homepage = "https://arrow.apache.org/datafusion";
    changelog = "https://github.com/apache/arrow-datafusion/blob/${version}/datafusion/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
