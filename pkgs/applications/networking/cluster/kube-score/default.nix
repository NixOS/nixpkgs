{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube-score";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "zegl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FZbq7f8Urx3tlJOBPnPyp1enFsmtrxqNjR42CTNo6GI=";
  };

  vendorSha256 = "sha256-8Rg57Uj/hdNqAj40MKZ/5PObRkdsInbsRT1ZkRqGTfo=";

  meta = with lib; {
    description = "Kubernetes object analysis with recommendations for improved reliability and security";
    homepage    = "https://github.com/zegl/kube-score";
    license     = licenses.mit;
    maintainers = [ maintainers.j4m3s ];
  };
}
