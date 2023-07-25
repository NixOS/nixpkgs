{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeconform";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "yannh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TPT+zO5WHW/D04dLMJLJ7uAYoDLky75kWqaN7PsyzEo=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "A FAST Kubernetes manifests validator, with support for Custom Resources!";
    homepage    = "https://github.com/yannh/kubeconform/";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
