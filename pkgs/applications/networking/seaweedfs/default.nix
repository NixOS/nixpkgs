{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.09";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "0yy5a7hr597vj6xbn7f5vzqdwnr637b3l1d62cmk0h7qbmh4anji";
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
