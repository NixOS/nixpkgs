{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "bitrise";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "bitrise-io";
    repo = "bitrise";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Cc38beZXb6thMjLILZygxpKrG7RLRy+7lJfRjoNSA5E=";
  };

  # many tests rely on writable $HOME/.bitrise and require network access
  doCheck = false;

  # Do not built other main packages in the repo (e.g. tools/gendocs, integrationtests)
  subPackages = [ "." ];

  vendorHash = null;
  ldflags = [
    "-X github.com/bitrise-io/bitrise/v3/version.VERSION=${finalAttrs.src.rev}"
    "-X github.com/bitrise-io/bitrise/v3/version.Commit=${finalAttrs.src.rev}"
    "-X github.com/bitrise-io/bitrise/v3/version.BuildNumber=0"
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
})
