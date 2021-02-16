{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.24";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-nz45vCRhWhgVG2pMA6TZVUIS4d9qBWW7NtTHuEsn4pg=";
  };

  vendorSha256 = "sha256-v0wFlwODZt3LC+yTuNS1hAAkoedVPfTeEIvs6rUGUa4=";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}
