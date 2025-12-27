{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubedock";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "joyrex2001";
    repo = "kubedock";
    rev = version;
    hash = "sha256-6I4fIaFtA4WjYQ0RO9tniUGH1p6hnYcazj6VNOyElLg=";
  };

  vendorHash = "sha256-QLiu014QowDqebDCXSxOH2TPHUG2d+34mlnbo3NdafA=";

  # config.Build not defined as it would break r-ryantm
  ldflags = [
    "-s"
    "-w"
    "-X github.com/joyrex2001/kubedock/internal/config.Version=${version}"
  ];

  env.CGO_ENABLED = 0;

  meta = {
    description = "Minimal implementation of the Docker API that will orchestrate containers on a Kubernetes cluster";
    homepage = "https://github.com/joyrex2001/kubedock";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mausch ];
    mainProgram = "kubedock";
  };
}
