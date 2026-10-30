{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "namespace-cli";
  version = "0.0.588";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0rz+Nn+v6+1BSDoujmIvat9rQPfANyLyFJGV+otELdg=";
  };

  vendorHash = "sha256-13NNfukXwjB59LCYhtBCsPOgyk+m4VzDVE4saR0rshg=";

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
