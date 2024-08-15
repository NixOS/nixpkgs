{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-evict-pod";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "rajatjindal";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yA88GDcu1Sg8d5RCC4yiDPYZPxDSnke/4X7nSBSGf88=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "This plugin evicts the given pod and is useful for testing pod disruption budget rules";
    mainProgram = "kubectl-evict-pod";
    homepage    = "https://github.com/rajatjindal/kubectl-evict-pod";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
