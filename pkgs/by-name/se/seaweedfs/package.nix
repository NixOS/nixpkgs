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
  version = "4.16";

  src = fetchFromGitHub {
    owner = "seaweedfs";
    repo = "seaweedfs";
    tag = finalAttrs.version;
    hash = "sha256-BRdI/50YxwdCdBj91w6OPgTcOb7JkshkVSD8b8bHcYA=";
  };

  vendorHash = "sha256-XbfKYftKfbJDkbp9DwVAs56w5lMvqdlW5cwhhivniBM=";

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
    rm -rf unmaintained test/s3 test/fuse_integration test/kafka test/sftp test/tus test/volume_server
    # TestECEncodingVolumeLocationTimingBug, TestECEncodingMasterTimingRaceCondition: weed binary not found
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
