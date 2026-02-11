{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kuttl";
  version = "0.24.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner = "kudobuilder";
    repo = "kuttl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Hkq1VukyImRLSQrOtH7IJyt2S8Zl+SNiWJfX4HpiOI4=";
  };

  vendorHash = "sha256-et/52c++8pgVgguCbPidVg0zFm9p7SVYI97N8sQ2KYQ=";

  subPackages = [ "cmd/kubectl-kuttl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kudobuilder/kuttl/internal/version.gitVersion=${finalAttrs.version}"
  ];

  meta = {
    description = "KUbernetes Test TooL (KUTTL) provides a declarative approach to testing production-grade Kubernetes operators";
    homepage = "https://github.com/kudobuilder/kuttl";
    license = lib.licenses.asl20;
    mainProgram = "kubectl-kuttl";
  };
})
