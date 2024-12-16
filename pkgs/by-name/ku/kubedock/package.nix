{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubedock";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "joyrex2001";
    repo = "kubedock";
    rev = version;
    hash = "sha256-413VUnVYPHKoy9r/XQ4An/TNfEjozsGANfKawFN7Y08=";
  };

  vendorHash = "sha256-S/0oyps1zrbncfy31C6SV13gt/oE+GeXGxD0KaKCn/s=";

  # config.Build not defined as it would break r-ryantm
  ldflags = [
    "-s"
    "-w"
    "-X github.com/joyrex2001/kubedock/internal/config.Version=${version}"
  ];

  CGO_ENABLED = 0;

  meta = with lib; {
    description = "Minimal implementation of the Docker API that will orchestrate containers on a Kubernetes cluster";
    homepage = "https://github.com/joyrex2001/kubedock";
    license = licenses.mit;
    maintainers = with maintainers; [ mausch ];
    mainProgram = "kubedock";
  };
}
