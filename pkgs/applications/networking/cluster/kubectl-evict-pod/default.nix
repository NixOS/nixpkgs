{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-evict-pod";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "rajatjindal";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z4fJzU317p7K+klcDQAukXAfZOpHd3PlH5fKO0PgKHA=";
  };

  vendorSha256 = "sha256-8VTrywlzrzoBEi/xOqkwhGW/R2B2oGqgh01Gv9FcW80=";

  meta = with lib; {
    description = "This plugin evicts the given pod and is useful for testing pod disruption budget rules";
    homepage    = "https://github.com/rajatjindal/kubectl-evict-pod";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
