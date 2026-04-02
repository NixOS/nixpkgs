{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libredirect,
  iana-etc,
  testers,
  seaweedfs,
}:

buildGoModule (finalAttrs: {
  pname = "seaweedfs";
  version = "4.18";
  checkFlags = [ "-timeout=20m" ];

  src = fetchFromGitHub {
    owner = "seaweedfs";
    repo = "seaweedfs";
    tag = finalAttrs.version;
    hash = "sha256-XJ4poxnYR9KlJbKd6zAsEag1OvM35mUL633g5Gl+aII=";
  };

  vendorHash = "sha256-RzFDkKWsbMBWaFj2qpy+p+8oaQ/2MeQDbMCYjQykz/c=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libredirect.hook ];

  subPackages = [ "weed" ];

  ldflags = [
    "-s"
    "-X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=N/A"
  ];

  tags = [
    "elastic"
    "gocdk"
    "sqlite"
    "ydb"
    "tikv"
  ];

  preBuild = ''
    export GODEBUG=http2client=0
  '';

  preCheck = ''
    # Test all targets.
    unset subPackages

    # Remove unmaintained tests and those that require additional services.
    # TestECEncodingVolumeLocationTimingBug, TestECEncodingMasterTimingRaceCondition: weed binary not found
    rm -rf unmaintained test/s3 test/fuse_integration test/kafka test/sftp test/tus weed/filer/rocksdb

    # This leaves the .go helper files but removes the actual test entry points.
    if [ -d "test/volume_server" ]; then
      find test/volume_server -name "*_test.go" -delete
    fi

    export checkFlagsArray=("-skip" "TestEcShardsDeleteLastShardRemovesEcx|TestRust")

    # Ensure the weed binary is available for tests that run it
    export PATH=$PATH:$NIX_BUILD_TOP/go/bin
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion {
    package = seaweedfs;
    command = "weed version";
  };

  meta = {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = with lib.maintainers; [
      azahi
      cmacrae
      wozeparrot
    ];
    mainProgram = "weed";
    license = lib.licenses.asl20;
  };
})
