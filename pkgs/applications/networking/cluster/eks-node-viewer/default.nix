{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-utn0OJX3NLCyAV4F01GIkvh/KFPv7vfLQMwso7x7yCw";
  };

  vendorSha256 = "sha256-28TKZYZM2kddXAusxmjhrKFy+ATU7kZM4Ad7zvP/F3A";

  meta = with lib; {
    description = "Tool to visualize dynamic node usage within a cluster";
    homepage = "https://github.com/awslabs/eks-node-viewer";
    changelog = "https://github.com/awslabs/eks-node-viewer/releases/tag/${version}";
    license = licenses.afl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
