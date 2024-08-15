{ lib
, fetchFromGitHub
, rustPlatform
, cmake
, fuse3
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "mountpoint-s3";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "mountpoint-s3";
    rev = "v${version}";
    hash = "sha256-0SygSRp2HXgLhW0BscRhH3H/WUstAf6VbQPJ35ffrRM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-nkTvVfbpi5yvWpRd1Tm6INi3PrR6mP8VkBpIVeCEkw0=";

  # thread 'main' panicked at cargo-auditable/src/collect_audit_data.rs:77:9:
  # cargo metadata failure: error: none of the selected packages contains these features: libfuse3
  auditable = false;

  nativeBuildInputs = [ cmake pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ fuse3 ];

  checkFlags = [
    #thread 's3_crt_client::tests::test_expected_bucket_owner' panicked at mountpoint-s3-client/src/s3_crt_client.rs:1123:47:
    #Create test client: ProviderFailure(Error(1173, "aws-c-io: AWS_IO_TLS_ERROR_DEFAULT_TRUST_STORE_NOT_FOUND, Default TLS trust store not found on this system. Trusted CA certificates must be installed, or \"override default trust store\" must be used while creating the TLS context."))
    #
    "--skip=s3_crt_client::tests::client_new_fails_with_greater_part_size"
    "--skip=s3_crt_client::tests::client_new_fails_with_smaller_part_size"
    "--skip=s3_crt_client::tests::test_endpoint_favors_env_variable"
    "--skip=s3_crt_client::tests::test_endpoint_favors_parameter_over_env_variable"
    "--skip=s3_crt_client::tests::test_endpoint_with_invalid_env_variable"
    "--skip=s3_crt_client::tests::test_expected_bucket_owner"
    "--skip=s3_crt_client::tests::test_user_agent_with_prefix"
    "--skip=s3_crt_client::tests::test_user_agent_without_prefix"
    "--skip=test_lookup_throttled_mock::head_object"
    "--skip=test_lookup_throttled_mock::list_object"
    "--skip=test_lookup_unhandled_error_mock"
    "--skip=tests::smoke"
    # fuse module not available on build machine ?
    #
    # fuse: device not found, try 'modprobe fuse' first
    # thread 'unmount_no_send' panicked at vendor/fuser/tests/integration_tests.rs:16:79:
    # called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: "No such file or directory" }
    "--skip=unmount_no_send"
    # sandbox issue ?
    #
    # thread 'mnt::test::mount_unmount' panicked at vendor/fuser/src/mnt/mod.rs:165:57:
    # called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: "No such file or directory" }
    "--skip=mnt::test::mount_unmount"
    "--skip=test_get_identity_document"
  ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/mountpoint-s3";
    description = "Simple, high-throughput file client for mounting an Amazon S3 bucket as a local file system";
    license = licenses.asl20;
    maintainers = with maintainers; [ lblasc ];
    platforms = platforms.linux;
  };
}
