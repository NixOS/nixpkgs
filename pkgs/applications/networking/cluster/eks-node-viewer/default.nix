{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+MQMChTNlphldzg05Pbi4HpT4SsI/bhTsC2GZK70dgs";
  };

  vendorSha256 = "sha256-fuZIPRZdG7jbyMbnk6ocHL8LNEfNQtc2R361QMFTswQ";

  meta = with lib; {
    description = "Tool to visualize dynamic node usage within a cluster";
    homepage = "https://github.com/awslabs/eks-node-viewer";
    license = licenses.afl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
