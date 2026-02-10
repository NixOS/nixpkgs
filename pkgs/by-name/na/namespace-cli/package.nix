{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "namespace-cli";
  version = "0.0.479";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EznGetJAjUMgQjTHgWA4nv3c6RobrSU28lEjN0PgsiE=";
  };

  vendorHash = "sha256-dk32fNNO5nN/RuYOu+vx8Gjxdcs1vt6K9CrV1iXn++E=";

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
