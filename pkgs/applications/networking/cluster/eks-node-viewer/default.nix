{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "6a915ff6c89b00d5e8ff90e3fe0ce65dd12eca17";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-+MQMChTNlphldzg05Pbi4HpT4SsI/bhTsC2GZK70dgs";
  };

  vendorSha256 = "sha256-fuZIPRZdG7jbyMbnk6ocHL8LNEfNQtc2R361QMFTswQ";

  meta = with lib; {
    description = "EKS Node Viewer";
    homepage = "https://github.com/awslabs/eks-node-viewer";
    changelog = "https://github.com/awslabs/eks-node-viewer/releases/tag/${version}";
    license = licenses.afl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
