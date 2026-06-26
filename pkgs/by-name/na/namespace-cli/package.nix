{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "namespace-cli";
  version = "0.0.525";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jGb1PKFxh1f542Gzb0CImmhVYNdrFwRiYAo862h8qoU=";
  };

  vendorHash = "sha256-3bbXWIiAqGn2twfCSTcYrpbwTOXJC0r8UgDs6iAkX1U=";

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
