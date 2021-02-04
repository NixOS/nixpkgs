{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.23";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-MMFVJoiVrA0zy4RM2nyhlu/JfnzIRpxrA3N1jm2R0jI=";
  };

  vendorSha256 = "sha256-UucbEBjIKRbZFd99BsnG6AAEIQ13+vzKe61k6ZPvE0A=";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}
