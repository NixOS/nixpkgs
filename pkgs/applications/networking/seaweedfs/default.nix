{ lib
, fetchFromGitHub
, buildGoModule
, testers
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "3.27";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-kvKUgw6A4UHOuDmKuOv+XS/0XiOf2ENWxl2WmJ4cVTE=";
  };

  vendorSha256 = "sha256-sgLHRDdi9gkcSzeBaDCxtbvWSzjTshb2WbmMyRepUKA=";

  subPackages = [ "weed" ];

  passthru.tests.version =
    testers.testVersion { package = seaweedfs; command = "weed version"; };

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = with maintainers; [ cmacrae ];
    mainProgram = "weed";
    license = licenses.asl20;
  };
}
