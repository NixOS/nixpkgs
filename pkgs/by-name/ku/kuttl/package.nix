{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kuttl";
  version = "0.29.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner = "kudobuilder";
    repo = "kuttl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6hHlfmwd2YMkMoIgOyhv5slUKjUpb1ZiwF5It5aIOiU=";
  };

  vendorHash = "sha256-3PE5iq+3vVON8mBiUqUE9TU3iYijOSQbwDV7m/qRMf4=";

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
