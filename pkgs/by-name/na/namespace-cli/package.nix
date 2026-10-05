{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "namespace-cli";
  version = "0.0.583";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8nm1CEAfEbDIDVolYOic+aEN3A0qfYH5LN6hHpSsQqA=";
  };

  vendorHash = "sha256-sINJLwkdxDlHxvL1dTn8XeMypuocMaKE1GoXZAdgEZM=";

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
