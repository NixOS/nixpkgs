{ lib
, fetchFromGitHub
, buildGoModule
, testVersion
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.88";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-B/gcuga82lZSLPKjYWAiLyvqf1FRQmHJsH2jqLkusjA=";
  };

  vendorSha256 = "sha256-N7zOrSMrCR/eOH+08TImI1q2AFGUuWN7xIt3CUVB9rM=";

  subPackages = [ "weed" ];

  passthru.tests.version =
    testVersion { package = seaweedfs; command = "weed version"; };

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = with maintainers; [ cmacrae raboof ];
    license = licenses.asl20;
  };
}
