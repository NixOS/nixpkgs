{ lib, buildGoModule, fetchFromGitHub}:

buildGoModule rec {
  pname = "kuttl";
  version = "0.11.1";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner  = "kudobuilder";
    repo   = "kuttl";
    rev    = "v${version}";
    sha256 = "sha256-jvearvhl2fQV5OOVmvf3C4MjE//wkVs8Ly9BIwv15/8=";
  };

  vendorSha256 = "sha256-EytHUfr6RbgXowYlfuajvNt9VwmGmvw9TBRtwYMAIh4=";

  subPackages = [ "cmd/kubectl-kuttl" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/kudobuilder/kuttl/pkg/version.gitVersion=${version}"
  ];

  meta = with lib; {
    description = "The KUbernetes Test TooL (KUTTL) provides a declarative approach to testing production-grade Kubernetes operators";
    homepage = "https://github.com/kudobuilder/kuttl";
    license = licenses.asl20;
    maintainers = with maintainers; [ diegolelis ];
    mainProgram = "kubectl-kuttl";
  };
}
