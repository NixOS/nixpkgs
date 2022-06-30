{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "fluxctl";
  version = "1.25.2";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flux";
    rev = version;
    sha256 = "sha256-OZLTT54InDPF+m5e4xtuAL311wCD16Ne/T0PbgiSaN4=";
  };

  vendorSha256 = "sha256-Q9THG76/B/gdfhf5wLxVXoAAzXeOjaaAyYaGKy9LeF0=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  subPackages = [ "cmd/fluxctl" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/fluxctl completion $shell > fluxctl.$shell
      installShellCompletion fluxctl.$shell
    done
  '';

  meta = with lib; {
    description = "CLI client for Flux, the GitOps Kubernetes operator";
    homepage = "https://github.com/fluxcd/flux";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih Br1ght0ne ];
  };
}
