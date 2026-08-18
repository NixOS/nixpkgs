{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "namespace-cli";
  version = "0.0.556";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vq9aOhQKz2nyjy+zXnaUxGbTrPBmyWeR0n26kReRd3I=";
  };

  vendorHash = "sha256-x4GWkINfOzcLFg7mCHG80Dpz7tkdcEDMj1oPAXM2n8w=";

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
