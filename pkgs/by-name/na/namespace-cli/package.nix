{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "namespace-cli";
  version = "0.0.478";

  src = fetchFromGitHub {
    owner = "namespacelabs";
    repo = "foundation";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AGERHGA2jPEXZqueMzVRtVF3UJIEGxX0glVxjS4OuiU=";
  };

  vendorHash = "sha256-FfQMnZD+H0LDLPThOz8BJ6FN/B9pDVT5nt84AmpawO0=";

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
