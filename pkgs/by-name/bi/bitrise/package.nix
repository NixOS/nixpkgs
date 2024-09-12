{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "bitrise";
  version = "2.20.1";

  src = fetchFromGitHub {
    owner = "bitrise-io";
    repo = "bitrise";
    rev = version;
    hash = "sha256-M1OAMppeY13fXclycUXwp2H1GSLVJRNV11QxAvNLQuQ=";
  };

  # many tests rely on writable $HOME/.bitrise and require network access
  doCheck = false;

  vendorHash = null;
  ldflags = [
    "-X github.com/bitrise-io/bitrise/version.Commit=${src.rev}"
    "-X github.com/bitrise-io/bitrise/version.BuildNumber=0"
  ];
  CGO_ENABLED = 0;

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
