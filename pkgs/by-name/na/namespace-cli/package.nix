{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "namespace-cli";
  version = "0.0.441";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
    hash = "sha256-qnKt6tXHHPt1uB9JY70atnOLwXgal0YO9n2w60S8lJk=";
  };

  vendorHash = "sha256-p3ciuSL3lJHLbWVsfKiaKZ+gjxCZCOBhXcucxBUVIEs=";

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
