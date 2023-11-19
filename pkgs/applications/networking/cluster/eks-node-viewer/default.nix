{ lib, buildGoModule, fetchFromGitHub, testers, eks-node-viewer }:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kfX9BzARDWUOBIu67j60K38uwkRELxd/gXtEHOHAXS8=";
  };

  vendorHash = "sha256-7axI7R8cTntc1IcOwVPmPj8MHeIvhbnkYKQdqu5fZOU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.builtBy=nixpkgs"
    "-X=main.commit=${src.rev}"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = eks-node-viewer;
    };
  };

  meta = with lib; {
    description = "Tool to visualize dynamic node usage within a cluster";
    homepage = "https://github.com/awslabs/eks-node-viewer";
    changelog = "https://github.com/awslabs/eks-node-viewer/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
