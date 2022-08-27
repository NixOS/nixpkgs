{ lib
, fetchFromGitHub
, buildGoModule
, testers
, seaweedfs
}:

buildGoModule rec {
  pname = "seaweedfs";
  version = "3.23";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-Pq0t8KDrmPfkJ0sWtpw1iAwycLj+YIuYIanyqEjdf5A=";
  };

  vendorSha256 = "sha256-YbdGtB6BEo8RoEYXjj1NG8bXMDojddd1UY0IXQK1Kgo=";

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
