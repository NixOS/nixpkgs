{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "namespace-cli";
  version = "0.0.301";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
    hash = "sha256-e2le7yIzgb3dReniU7grR814xDWhGgckuyzx4omeRYI=";
  };

  vendorHash = "sha256-jYkEXoCxqlxLF7oRc7H+/pMwkphOEwt2qUFkg+JOKVA=";

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
