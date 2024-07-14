{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "namespace-cli";
  version = "0.0.381";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
    hash = "sha256-WQBA3NtkxrN3NzKl/DsIlp8gdqQpo05n1MZzIKNJdQc=";
  };

  vendorHash = "sha256-y+mXUzkY5w2hYECtfcBBUCWsRwhip6IhX617lRX698Q=";

  subPackages = ["cmd/nsc" "cmd/ns" "cmd/docker-credential-nsc"];

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
