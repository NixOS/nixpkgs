{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "bitrise";
  version = "2.34.5";

  src = fetchFromGitHub {
    owner = "bitrise-io";
    repo = "bitrise";
    rev = "v${version}";
    hash = "sha256-QsGF5lDnY55OGdFagGJfXcq9/2P6qzmoHx64ijOkRfo=";
  };

  # many tests rely on writable $HOME/.bitrise and require network access
  doCheck = false;

  # resolves error: main module (github.com/bitrise-io/bitrise/v2) does not contain package github.com/bitrise-io/bitrise/v2/integrationtests/config
  excludedPackages = [
    "./integrationtests"
  ];

  vendorHash = null;
  ldflags = [
    "-X github.com/bitrise-io/bitrise/version.Commit=${src.rev}"
    "-X github.com/bitrise-io/bitrise/version.BuildNumber=0"
  ];
  env.CGO_ENABLED = 0;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/bitrise-io/bitrise/releases";
    description = "CLI for running your Workflows from Bitrise on your local machine";
    homepage = "https://bitrise.io/cli";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "bitrise";
    maintainers = with lib.maintainers; [ ofalvai ];
  };
}
