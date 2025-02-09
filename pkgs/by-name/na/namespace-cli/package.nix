{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "namespace-cli";
  version = "0.0.402";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
    hash = "sha256-1QqBfi9OL2b+mR2ubtErVtIFXIK95vO9WrzrdZWqqAo=";
  };

  vendorHash = "sha256-narbmKAmVFtTR8JkGkem8aHScoXiZ+0V+3a9Vkd7BSA=";

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
