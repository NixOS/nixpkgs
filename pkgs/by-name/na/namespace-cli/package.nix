{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "namespace-cli";
  version = "0.0.433";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
    hash = "sha256-ZkRo6tPYJk3ym7LDkucnoLTbmCRJ7nup4zB/7wY6dTc=";
  };

  vendorHash = "sha256-/JFiCflhJsu8Tkkw0Pqj0iOauVXXLaNuPRK524YVN98=";

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

  meta = {
    mainProgram = "nsc";
    maintainers = with lib.maintainers; [ techknowlogick ];
    license = lib.licenses.asl20;
    changelog = "https://github.com/namespacelabs/foundation/releases/tag/v${version}";
    homepage = "https://github.com/namespacelabs/foundation";
    description = "Command line interface for the Namespaces platform";
  };
}
