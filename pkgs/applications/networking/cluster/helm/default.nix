{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helm";
  version = "3.6.2";
  gitCommit = "ee407bdf364942bcb8e8c665f82e15aa28009b71";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "1s40zbk83s1kylcglydw356282virf1828v9waj1zs1gjnjml69h";
  };
  vendorSha256 = "06ccsy30kd68ml13l5k7d4225vlax3fm2pi8dapsyr4gdr234c1x";

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
