{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "bitrise";
<<<<<<< HEAD
  version = "2.36.0";
=======
  version = "2.35.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "bitrise-io";
    repo = "bitrise";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Sr/xpPLrlAaNv4r4fZ1/QFbamvGWFMfsOKSbaWdlAI0=";
=======
    hash = "sha256-RjtOo8+vXKeZbTtnwmUq1t8WwZUJypSUoQSJtr9xd70=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
