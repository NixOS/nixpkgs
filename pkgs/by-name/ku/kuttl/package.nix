{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kuttl";
  version = "0.23.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner = "kudobuilder";
    repo = "kuttl";
    rev = "v${version}";
    sha256 = "sha256-5WdI3Wc0BgjWUFCtHF6M75RPqRvVOxjNJDSQe1rElkk=";
  };

  vendorHash = "sha256-Hx/PanggFE7rT4ku3toEvPF3XCatxDwUBfB5c6JvHFI=";

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
    mainProgram = "kubectl-kuttl";
  };
}
