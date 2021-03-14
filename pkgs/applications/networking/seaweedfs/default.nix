{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.29";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-wyqshtL3wGrmb1oEMOMk2QmDXW9M5tt9d1QEtMFiXa4=";
  };

  vendorSha256 = "sha256-uT/Y/TfpqDyOUElc4M/w/v77bWF3tTJz+Yu0KRMcxk4=";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}
