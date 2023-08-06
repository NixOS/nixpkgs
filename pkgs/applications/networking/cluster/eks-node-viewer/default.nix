{ lib, buildGoModule, fetchFromGitHub, testers, eks-node-viewer }:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zuez0ELtlphMHP/Pxu5ARnYhkmLJW/ehNrTLXSGmGL8=";
  };

  vendorHash = "sha256-n2H6hiKZqujrJyojO2uQTIMLMHaX//t7328GPK6hxH0=";

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
