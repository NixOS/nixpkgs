{ lib
, fetchFromGitHub
, buildGoModule
, testVersion
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.50";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-ai8/XryFw/7GYuWAmLkqHzK97QgTBPyE6m3dflck94w=";
  };

  vendorSha256 = "sha256-gJQDcACMWZWS4CgS2NDALoBzxu7Hh4ZW3f0gUFUALCM=";

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
