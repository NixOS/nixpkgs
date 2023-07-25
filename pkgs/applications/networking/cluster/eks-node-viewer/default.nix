{ lib, buildGoModule, fetchFromGitHub, testers, eks-node-viewer }:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-k8WCD/FirC62WSmcgM5PmTs/hZEmR9xpneyZ1orcoMI=";
  };

  vendorHash = "sha256-nUVFQruesP6a74s4UfVrd+2P2lmn1NyVrJBS2dR2QdI=";

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
