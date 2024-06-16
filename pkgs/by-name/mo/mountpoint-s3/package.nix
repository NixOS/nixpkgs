{ lib
, fetchFromGitHub
, rustPlatform
, cmake
, fuse3
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "mountpoint-s3";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "mountpoint-s3";
    rev = "v${version}";
    hash = "sha256-1d2PPbTheUcHw2xS5LEcdchnfwu7szBApv+FnPaxt+I=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-tBi41kdaa4mVHh0MkXJ8kaG1e3CQURIKVk9Lboy1N8Y=";

  # thread 'main' panicked at cargo-auditable/src/collect_audit_data.rs:77:9:
  # cargo metadata failure: error: none of the selected packages contains these features: libfuse3
  auditable = false;

  nativeBuildInputs = [ cmake pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ fuse3 ];

  checkFlags = [
    #thread 's3_crt_client::tests::test_expected_bucket_owner' panicked at mountpoint-s3-client/src/s3_crt_client.rs:1123:47:
    #Create test client: ProviderFailure(Error(1173, "aws-c-io: AWS_IO_TLS_ERROR_DEFAULT_TRUST_STORE_NOT_FOUND, Default TLS trust store not found on this system. Trusted CA certificates must be installed, or \"override default trust store\" must be used while creating the TLS context."))
    #
    "--skip=s3_crt_client::tests::test_expected_bucket_owner"
    "--skip=s3_crt_client::tests::test_user_agent_with_prefix"
    "--skip=s3_crt_client::tests::test_user_agent_without_prefix"
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
    description = "A simple, high-throughput file client for mounting an Amazon S3 bucket as a local file system";
    license = licenses.asl20;
    maintainers = with maintainers; [ lblasc ];
    platforms = platforms.linux;
  };
}
