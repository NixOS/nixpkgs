{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kuttl";
  version = "0.27.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner = "kudobuilder";
    repo = "kuttl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-FZCEfQxum053Sd3Ro7Gj6M5p575zhLQ+wmUcYAbA/ZA=";
  };

  vendorHash = "sha256-ohjf7o4RujGcx6ptPLuahqTUZWD2xUS3UUBq0AlzhOU=";

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
