{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "namespace-cli";
  version = "0.0.408";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
    hash = "sha256-Cjxoh+fWI20KRTOgTCJ2KOtS3e7GuitreS85S2BbtNU=";
  };

  vendorHash = "sha256-OBFzi8n29gnyMvwLYsmJz8oLLvR2i6YRNrfWxkRwC/s=";

  subPackages = [
    "cmd/nsc"
    "cmd/ns"
    "cmd/docker-credential-nsc"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X namespacelabs.dev/foundation/internal/cli/version.Tag=v${version}"
  ];

  meta = with lib; {
    mainProgram = "nsc";
    maintainers = with maintainers; [ techknowlogick ];
    license = licenses.asl20;
    changelog = "https://github.com/namespacelabs/foundation/releases/tag/v${version}";
    homepage = "https://github.com/namespacelabs/foundation";
    description = "Command line interface for the Namespaces platform";
  };
}
