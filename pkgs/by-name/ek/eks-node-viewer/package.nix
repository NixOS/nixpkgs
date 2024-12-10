{ lib, buildGoModule, fetchFromGitHub, testers, eks-node-viewer }:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BK84hxbwZSJDO5WoyborJnVBS5pB69jTMU1csgiT0sw=";
  };

  vendorHash = "sha256-EJAL5jNftA/g5H6WUMBJ98EyRp7QJ1C53EKr6GRz71I=";

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
