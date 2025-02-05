{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubedock";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "joyrex2001";
    repo = "kubedock";
    rev = version;
    hash = "sha256-O8heDxfYmBV4sSdBZOQri+FMHJMrRW9+kai1S62ffQY=";
  };

  vendorHash = "sha256-9mPcHMNAkjO8Ae9HcgvdR2+UUPMYmE2oTfYksZ/KL+Y=";

  # config.Build not defined as it would break r-ryantm
  ldflags = [
    "-s"
    "-w"
    "-X github.com/joyrex2001/kubedock/internal/config.Version=${version}"
  ];

  env.CGO_ENABLED = 0;

  meta = with lib; {
    description = "Minimal implementation of the Docker API that will orchestrate containers on a Kubernetes cluster";
    homepage = "https://github.com/joyrex2001/kubedock";
    license = licenses.mit;
    maintainers = with maintainers; [ mausch ];
    mainProgram = "kubedock";
  };
}
