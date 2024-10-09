{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "namespace-cli";
  version = "0.0.392";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${version}";
    hash = "sha256-o0/kAat8vEhVE9ut179yBpvLuMFw6bNha2qT1ddvs7E=";
  };

  vendorHash = "sha256-XO/Fj66w17zLJIQHv6F6czReqtqyCORAgCRtjwRaTbo=";

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
