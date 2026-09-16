{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubedock";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "joyrex2001";
    repo = "kubedock";
    rev = finalAttrs.version;
    hash = "sha256-Mdgs0PIHXWFHr/C/iyStHzBsjnpW17zeQn4bhrF5AU8=";
  };

  vendorHash = "sha256-P2s8bKHohZ4CAATdYFoep6NZwHxBJYOc6+fAUyhFR3I=";

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
