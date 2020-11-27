{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "08jv8dbvdygcm6wzvncx89p8cn9mbjn4lj8rf5svq8lr7zk1rvpw";
  };

  vendorSha256 = "0g344dj325d35i0myrzhg5chspqnly40qp910ml6zrmp7iszc1mw";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}
