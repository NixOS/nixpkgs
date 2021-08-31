{ lib
, fetchFromGitHub
, buildGoModule
, testVersion
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.63";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-sC7BUbI4BcNp7XqNtgxHuzvksyVFP+gXHxldQPy/7UU=";
  };

  vendorSha256 = "sha256-PEMc2NUiGKaolVGwviNRvtpVyhypWsJlNWZ0ysjy+YE=";

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
