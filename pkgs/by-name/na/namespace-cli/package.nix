{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "namespace-cli";
  version = "0.0.443";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
    hash = "sha256-LprQhUIh5wcxiR3sf2+cT3fg458KDDv9f7Sytcs1NC8=";
  };

  vendorHash = "sha256-913vffq86pju2UKW0UkTm8qE7bylR9n0SgacELIRhVY=";

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
