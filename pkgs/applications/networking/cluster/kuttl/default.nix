{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kuttl";
  version = "0.15.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner = "kudobuilder";
    repo = "kuttl";
    rev = "v${version}";
    sha256 = "sha256-u+j1ulM6B238qXvLMJZwLqglr9CGk81MsnBYiNiZVJQ=";
  };

  vendorHash = "sha256-taJAQPa0EA0Ph9OpCs7jzLqBV61kVstZrWyNEYc/GBk=";

  subPackages = [ "cmd/kubectl-kuttl" ];

  ldflags = [
    "-s"
    "-w"
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
