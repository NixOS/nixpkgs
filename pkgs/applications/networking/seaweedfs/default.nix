{ lib
, fetchFromGitHub
, buildGoModule
, testers
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "3.24";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-cnaktk2POuSPazvU8ChAJHbIUR0O34NTPEcjDQKHU08=";
  };

  vendorSha256 = "sha256-jj1UxohdkmtYjLMoZgkUrIsPmhkOal+KdqKzs8qfRJM=";

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
