{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kuttl";
  version = "0.26.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner = "kudobuilder";
    repo = "kuttl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-kyJBUNzicg/8IDpWTTVfSaqIc05RK3ebgJgPqkwU0kA=";
  };

  vendorHash = "sha256-N9D1bXaVy1AT9GzcggvMJh7AWmCjxtWEbTlrBsBfZlc=";

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
