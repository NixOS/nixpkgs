{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helm";
  version = "3.5.4";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "sha256-u8GJVOubPlIG88TFG5+OvbovMz4Q595wWo2YCwuTgG8=";
  };
  vendorSha256 = "sha256-zdZxGiwgx8c0zt9tQebJi7k/LNNYjhNInsVeBbxPsgE=";

  doCheck = false;

  subPackages = [ "cmd/helm" ];
  buildFlagsArray = [ "-ldflags=-w -s -X helm.sh/helm/v3/internal/version.version=v${version}" ];

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
