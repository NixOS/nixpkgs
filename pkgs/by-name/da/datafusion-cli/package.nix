{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "datafusion-cli";
  version = "54.1.0";

  src = fetchFromGitHub {
    name = "datafusion-cli-source";
    owner = "apache";
    repo = "datafusion";
    tag = finalAttrs.version;
    hash = "sha256-zeR6eyU4Cc5gHiE331ap8wuyYEj7s7BgqB+oOKwMfZw=";
  };

  cargoHash = "sha256-XXR1Turs+QwONZHq38MZHbcjv5DYZH9iqeuBl20gy3U=";

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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for Apache Arrow DataFusion";
    mainProgram = "datafusion-cli";
    homepage = "https://arrow.apache.org/datafusion";
    changelog = "https://github.com/apache/datafusion/blob/${finalAttrs.src.tag}/datafusion/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
