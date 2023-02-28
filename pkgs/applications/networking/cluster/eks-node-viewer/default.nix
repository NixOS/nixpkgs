{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PqZVVfq/cUtkmpruJfxphCeQWMXKEmE2AgulgUX9310";
  };

  vendorSha256 = "sha256-PJ6TakF2yN8eB/SV5Dx164lDZDi4Hr4N2ZW8dzz8jcg";

  meta = with lib; {
    description = "Tool to visualize dynamic node usage within a cluster";
    homepage = "https://github.com/awslabs/eks-node-viewer";
    license = licenses.afl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
