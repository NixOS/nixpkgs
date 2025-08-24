{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "namespace-cli";
  version = "0.0.437";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
    hash = "sha256-NWqk6XOcFwNHfILTisq7SFd88tRce5bTnE25+Ktu4CE=";
  };

  vendorHash = "sha256-BYPwEct3t3JB4xHf9jiy59JnOMZu4NpelX46RAAJD+0=";

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
