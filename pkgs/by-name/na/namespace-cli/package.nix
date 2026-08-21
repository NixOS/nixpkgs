{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "namespace-cli";
  version = "0.0.557";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EAHsfbCNLSZpfaWLbLh6Eb5D8PE7ZG4HBXuiH7okfF4=";
  };

  vendorHash = "sha256-b9L3K2YxD7zhrZthgDzovNnYzaJda4XFYObokG7Nt28=";

  subPackages = [
    "cmd/nsc"
    "cmd/ns"
    "cmd/docker-credential-nsc"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X namespacelabs.dev/foundation/internal/cli/version.Tag=v${finalAttrs.version}"
  ];

  meta = {
    mainProgram = "nsc";
    maintainers = with lib.maintainers; [ techknowlogick ];
    license = lib.licenses.asl20;
    changelog = "https://github.com/namespacelabs/foundation/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/namespacelabs/foundation";
    description = "Command line interface for the Namespaces platform";
  };
})
