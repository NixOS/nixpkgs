{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kuttl";
  version = "0.28.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner = "kudobuilder";
    repo = "kuttl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2BsEKR6qJD5GLASrOh1hPKR3RmoCRzS+h1H58c0zCgA=";
  };

  vendorHash = "sha256-fnjgSVefNqfjV5AU7fOWClkcxGv/jRW/iyaNjuXtJSA=";

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
