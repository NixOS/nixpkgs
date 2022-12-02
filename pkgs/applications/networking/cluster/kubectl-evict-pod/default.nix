{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-evict-pod";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "rajatjindal";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-alU1c1ppn4cQi582kcA/PIAJJt73i3uG02cQvSYij1A=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "This plugin evicts the given pod and is useful for testing pod disruption budget rules";
    homepage    = "https://github.com/rajatjindal/kubectl-evict-pod";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
