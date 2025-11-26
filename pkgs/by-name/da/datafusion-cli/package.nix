{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "datafusion-cli";
  version = "51.0.0";

  src = fetchFromGitHub {
    name = "datafusion-cli-source";
    owner = "apache";
    repo = "arrow-datafusion";
    tag = finalAttrs.version;
    hash = "sha256-0gAcWH22klYmODY2Dht7Eevg28d46XbVuFF7KPIqXGA=";
  };

  cargoHash = "sha256-NA/aB3HIGyI3dEhFUXCWxYkfJgKmBuLRmUJPXqUGYvk=";

  buildAndTestSubdir = "datafusion-cli";

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

  # timeout
  doCheck = false;

  meta = {
    description = "CLI for Apache Arrow DataFusion";
    mainProgram = "datafusion-cli";
    homepage = "https://arrow.apache.org/datafusion";
    changelog = "https://github.com/apache/arrow-datafusion/blob/${finalAttrs.version}/datafusion/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
