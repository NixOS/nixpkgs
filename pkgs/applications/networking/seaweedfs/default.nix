{ lib
, fetchFromGitHub
, buildGoModule
, testVersion
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.80";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-g3Jrh4sbw1Lh3wmx3gmfzFNHQSzfQrJ4PsrYvYdDpeQ=";
  };

  vendorSha256 = "sha256-QlIxkY29KzYPGGQw7NEwPRnKEPY3q32DCL1OBQNQXMY=";

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
