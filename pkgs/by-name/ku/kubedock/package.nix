{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubedock";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "joyrex2001";
    repo = "kubedock";
    rev = version;
    hash = "sha256-Kw18zTTZDWB4I4HdiHUv4GTBT4qC3ChAdL/60VF1rjk=";
  };

  vendorHash = "sha256-uICdDBOctvFlLIXC10UqAzUyJSbpq206kcxwJqAfLtk=";

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
