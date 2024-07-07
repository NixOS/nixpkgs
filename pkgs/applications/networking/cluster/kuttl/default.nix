{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kuttl";
  version = "0.17.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner = "kudobuilder";
    repo = "kuttl";
    rev = "v${version}";
    sha256 = "sha256-jU/w4SA6gt2xCdJiSNkY2S2RQCuyj84IW1w8DDPvtW0=";
  };

  vendorHash = "sha256-OXmT7GTnD/TKjCN4po3vLJ0pZgsEEUGnuF5RtOm00hM=";

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
