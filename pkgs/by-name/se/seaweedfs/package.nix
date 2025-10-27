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
  version = "3.97";

  src = fetchFromGitHub {
    owner = "seaweedfs";
    repo = "seaweedfs";
    tag = finalAttrs.version;
    hash = "sha256-h8pyjC/hbKfvt4hEKuq0v5osLMWNU+6mYqFGqsZFqXs=";
  };

  vendorHash = "sha256-KRO0aDGOVx1neXcGsYYqcpD0tAqtR3GSBDhFz5TbQBs=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libredirect.hook ];

  subPackages = [ "weed" ];

  ldflags = [
    "-w"
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
    rm -rf unmaintained test/s3 test/fuse_integration
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
