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

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  vendorHash = null;

  meta = with lib; {
    description = "FAST Kubernetes manifests validator, with support for Custom Resources";
    mainProgram = "kubeconform";
    homepage = "https://github.com/yannh/kubeconform/";
    license = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
