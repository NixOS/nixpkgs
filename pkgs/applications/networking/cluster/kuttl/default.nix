{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kuttl";
  version = "0.14.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner = "kudobuilder";
    repo = "kuttl";
    rev = "v${version}";
    sha256 = "sha256-xQS7qCUTM3X4SpUZfxKHb08poJ2W52R7+TNe4BFL5sY=";
  };

  vendorSha256 = "sha256-u8Ezk78CrAhSeeMVXj09/Hiegtx+ZNKlr/Fg0O7+iOY=";

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
