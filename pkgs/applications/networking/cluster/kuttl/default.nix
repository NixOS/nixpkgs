{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kuttl";
  version = "0.16.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner = "kudobuilder";
    repo = "kuttl";
    rev = "v${version}";
    sha256 = "sha256-Kz8+RsLpKwXk4f3k/kBqSFGB9AvA/D6kYBtPEl6aSH8=";
  };

  vendorHash = "sha256-IgfPXT4BhfZZVOa7eO1wKUKiDVMcN8vmH11qdWfvFww=";

  subPackages = [ "cmd/kubectl-kuttl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kudobuilder/kuttl/pkg/version.gitVersion=${version}"
  ];

  meta = with lib; {
    description = "KUbernetes Test TooL (KUTTL) provides a declarative approach to testing production-grade Kubernetes operators";
    homepage = "https://github.com/kudobuilder/kuttl";
    license = licenses.asl20;
    maintainers = with maintainers; [ diegolelis ];
    mainProgram = "kubectl-kuttl";
  };
}
