{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "helm";
  version = "3.7.0";
  gitCommit = "eeac83883cb4014fe60267ec6373570374ce770b";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "sha256-dV6Bx6XVzPqaRBeCzEFR473xnxjff4f24jd5vETVX78=";
  };
  vendorSha256 = "sha256-Q/ycpLCIvf+PP+03ug3fKT+uIOdzDwP7709VfFVJglk=";

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
