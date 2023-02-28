{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-k3UezzrLwv4eL8n2qefP8ae4ekNLhcHc8PMH3+Zq92c";
  };

  vendorSha256 = "sha256-A7XGbGTbx1qr/zpfXyJqIDb3EU8IVGO6sTNg5bg/jMk";

  meta = with lib; {
    description = "Tool to visualize dynamic node usage within a cluster";
    homepage = "https://github.com/awslabs/eks-node-viewer";
    changelog = "https://github.com/awslabs/eks-node-viewer/releases/tag/${version}";
    license = licenses.afl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
