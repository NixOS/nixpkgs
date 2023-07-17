{ lib
, fetchFromGitHub
, fetchpatch
, buildGoModule
, testers
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "3.54";

  src = fetchFromGitHub {
    owner = "seaweedfs";
    repo = "seaweedfs";
    rev = version;
    hash = "sha256-2E2ANJIKWhUUxxSqk5+QROeoKnp1Akl5Bp+i8pPTkuQ=";
  };

  patches = [
    # Fix build on aarch64-darwin
    # (remove again when v3.55 is released)
    # https://github.com/seaweedfs/seaweedfs/pull/4679
    (fetchpatch {
      url = "https://github.com/seaweedfs/seaweedfs/commit/1bfc9581e0bc04f394187a0d39f319ad65df5aca.patch";
      hash = "sha256-znQFtm8BYAjuvXa+vibawBb+uhnjOL9/o0sXNoXwLk8=";
    })
  ];

  vendorHash = "sha256-VK7BmApGq+X1oNjcwCSYHcEvVjL87t8fgJXLNQSfy3I=";

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

    # Remove unmaintained tests ahd those that require additional services.
    rm -rf unmaintained test/s3
  '';

  passthru.tests.version = testers.testVersion {
    package = seaweedfs;
    command = "weed version";
  };

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = with maintainers; [ azahi cmacrae wozeparrot ];
    mainProgram = "weed";
    license = licenses.asl20;
  };
}
