{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "0ymkkj7nf70rwlzfj6x78dx07mv32qvcb6dp8m92hc4s2ckdz3ly";
  };

  vendorSha256 = "1r7k0rzizs61r4gqqll7l2j7mdpi3w1ja6l4w6vxgzb45h2sjhi7";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}
