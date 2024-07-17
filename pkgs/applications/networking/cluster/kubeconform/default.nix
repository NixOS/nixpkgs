{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubeconform";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "yannh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pE5DDtraN5ubEsM+QfY5y/dqM31VsQ3FeM/c56AJ648=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "A FAST Kubernetes manifests validator, with support for Custom Resources!";
    mainProgram = "kubeconform";
    homepage = "https://github.com/yannh/kubeconform/";
    license = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
