{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "smtprelay";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "decke";
    repo = "smtprelay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o4nB1j2NmqeQeTpJoY8mKUv60L8dTLQxjNtfCIZ2u0M=";
  };

  vendorHash = "sha256-d+NSghVEdEiHIUGR6MIj7d3dHYGtAeLbdJ7zwhHxOPo=";

  subPackages = [
    "."
  ];

  env.CGO_ENABLED = 0;

  # We do not supply the build time as the build wouldn't be reproducible otherwise.
  ldflags = [
    "-s"
    "-w"
    "-X=main.appVersion=v${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/decke/smtprelay";
    description = "Simple Golang SMTP relay/proxy server";
    mainProgram = "smtprelay";
    changelog = "https://github.com/decke/smtprelay/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juliusrickert ];
  };
})
