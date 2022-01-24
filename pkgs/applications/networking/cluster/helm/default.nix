{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helm";
  version = "3.7.2";
  gitCommit = "663a896f4a815053445eec4153677ddc24a0a361";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "sha256-MhBuwpgF1PBAZ5QwF7t4J1gqam2cMX+hkdZs7KoSD6I=";
  };
  vendorSha256 = "sha256-YDdpeVh9rG3MF1HgG7uuRvjXDr9Fcjuhrj16kpK8tsI=";

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
