{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.36";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-BVn+mV5SjyODcT+O8LXfGA42/Si5+GrdkjP0tAPiuTM=";
  };

  vendorSha256 = "sha256-qdgnoh+53o3idCfpkEFGK88aUVb2F6oHlSRZncs2hyY=";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}
