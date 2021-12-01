{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helm";
  version = "3.7.1";
  gitCommit = "1d11fcb5d3f3bf00dbe6fe31b8412839a96b3dc4";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "sha256-NjBG3yLtvnAXziLH/ALRJVaFW327qo7cvnf1Jpq3QlI=";
  };
  vendorSha256 = "sha256-gmyF/xuf5dTxorgqvW4PNA1l2SQ2oJuZCAFw7d8ufGc=";

  doCheck = false;

  subPackages = [ "cmd/helm" ];
  ldflags = [
    "-w" "-s"
    "-X helm.sh/helm/v3/internal/version.version=v${version}"
    "-X helm.sh/helm/v3/internal/version.gitCommit=${gitCommit}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    $out/bin/helm completion bash > helm.bash
    $out/bin/helm completion zsh > helm.zsh
    installShellCompletion helm.{bash,zsh}
  '';

  meta = with lib; {
    homepage = "https://github.com/kubernetes/helm";
    description = "A package manager for kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ rlupton20 edude03 saschagrunert Frostman Chili-Man ];
  };
}
