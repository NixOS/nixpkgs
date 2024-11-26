{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubeconform";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "yannh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Yq9lJ3rSG8v/PeofkZrnO2nzEgtyB5vtNafKabp8hnQ=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "FAST Kubernetes manifests validator, with support for Custom Resources!";
    mainProgram = "kubeconform";
    homepage = "https://github.com/yannh/kubeconform/";
    license = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
