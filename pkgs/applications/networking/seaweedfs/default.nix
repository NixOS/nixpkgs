{ lib
, fetchFromGitHub
, buildGoModule
, testers
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.91";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-lpr+Z4INDUrMUArR9yU/US/d7rhQ3AcTS3bh/suOe4M=";
  };

  vendorSha256 = "sha256-T8JUc8UqdgBADWfQL1oY0lrwOOKTmbBiI7rtNiDvlGo=";

  subPackages = [ "weed" ];

  passthru.tests.version =
    testers.testVersion { package = seaweedfs; command = "weed version"; };

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = with maintainers; [ cmacrae raboof ];
    mainProgram = "weed";
    license = licenses.asl20;
  };
}
