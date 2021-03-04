{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.27";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-0KT/5seJs8GkatL4BsZ+r71t6AJrpHB6Q92sCvplKcQ=";
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
