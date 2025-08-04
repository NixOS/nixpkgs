{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubeconform";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "yannh";
    repo = "kubeconform";
    rev = "v${version}";
    sha256 = "sha256-FTUPARckpecz1V/Io4rY6SXhlih3VJr/rTGAiik4ALA=";
  };

  vendorHash = null;

  meta = {
    description = "FAST Kubernetes manifests validator, with support for Custom Resources";
    mainProgram = "kubeconform";
    homepage = "https://github.com/yannh/kubeconform/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.j4m3s ];
  };
}
