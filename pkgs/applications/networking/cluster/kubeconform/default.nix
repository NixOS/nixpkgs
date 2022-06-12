{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeconform";
  version = "0.4.13";

  src = fetchFromGitHub {
    owner = "yannh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hKsGti04pUZj02uzah7ccImmg/qn31ceVfk11aTa9rk=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "A FAST Kubernetes manifests validator, with support for Custom Resources!";
    homepage    = "https://github.com/yannh/kubeconform/";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
