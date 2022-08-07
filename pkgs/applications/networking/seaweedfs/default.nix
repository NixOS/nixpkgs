{ lib
, fetchFromGitHub
, buildGoModule
, testers
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "3.15";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-07cIqGKmw2Co7GEc/APiOWTgflUwDIQPQzs73XTAPQA=";
  };

  vendorSha256 = "sha256-4U96s9PJLuVuzgWXCMLKfXK/XK1EaC+ep2c8TpKVRlc=";

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
