{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubedock";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "joyrex2001";
    repo = "kubedock";
    rev = finalAttrs.version;
    hash = "sha256-mxOvk2o2Ke8AEA9SyuyqHr+G9A2qpzlE9rqKG7INr4w=";
  };

  vendorHash = "sha256-SROlRbpokMsnTscxF71upxmjhZPqTbkk50n0Htwh1lc=";

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
