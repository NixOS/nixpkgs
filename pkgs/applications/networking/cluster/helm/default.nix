{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helm";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "sha256-sVa7d69MuOjH1IhUMcXu79kEE0BKylLYx6yrOV/DExY=";
  };
  vendorSha256 = "sha256-PTAyRG6PZK+vaiheUd3oiu4iBGlnFjoCrci0CYbXjBk=";

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
