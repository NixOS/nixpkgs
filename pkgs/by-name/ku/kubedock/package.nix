{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubedock";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "joyrex2001";
    repo = "kubedock";
    rev = finalAttrs.version;
    hash = "sha256-ohriv6Lw5c+XvsENysplZ9FSbbVigjOILfOi3VpaGjI=";
  };

  vendorHash = "sha256-EwFNwJ/JTyt+Ua1qvKMEHMbgnMaLCWN7xphV2Q3xnLU=";

  # config.Build not defined as it would break r-ryantm
  ldflags = [
    "-s"
    "-w"
    "-X github.com/joyrex2001/kubedock/internal/config.Version=${finalAttrs.version}"
  ];

  env.CGO_ENABLED = 0;

  meta = {
    description = "Minimal implementation of the Docker API that will orchestrate containers on a Kubernetes cluster";
    homepage = "https://github.com/joyrex2001/kubedock";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mausch ];
    mainProgram = "kubedock";
  };
})
