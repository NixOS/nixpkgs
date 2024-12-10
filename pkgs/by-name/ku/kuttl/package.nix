{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kuttl";
  version = "0.19.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner = "kudobuilder";
    repo = "kuttl";
    rev = "v${version}";
    sha256 = "sha256-7fcVmLvRbKYuWuqwqZWlQf08YEyowcTxrp5RteV8qyU=";
  };

  vendorHash = "sha256-E6gzr9gCLbRaoJU/pYA2cAy0rv5SUVmwf0m34lchF+M=";

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
