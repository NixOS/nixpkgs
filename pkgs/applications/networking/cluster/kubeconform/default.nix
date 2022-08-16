{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeconform";
  version = "0.4.14";

  src = fetchFromGitHub {
    owner = "yannh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iLZhd1e4i6omyGhOvRJ/VsHehpAPfPHnypXru5Ruv0o=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "A FAST Kubernetes manifests validator, with support for Custom Resources!";
    homepage    = "https://github.com/yannh/kubeconform/";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
