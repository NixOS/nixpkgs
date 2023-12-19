{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "namespace-cli";
  version = "0.0.322";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
    hash = "sha256-noxzIz3klw6kYW6qe2rmhOVG5N+qu8NlkWeoR4TBne0=";
  };

  vendorHash = "sha256-/Q8P1m71pqxejVcfzHY+JC3+BPz0r3kc4PgQnNZM0SQ=";

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
    description = "A command line interface for the Namespaces platform";
  };
}
