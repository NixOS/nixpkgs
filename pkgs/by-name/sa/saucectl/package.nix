{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "saucectl";
  version = "0.198.0";

  src = fetchFromGitHub {
    owner = "saucelabs";
    repo = "saucectl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l9iiMyL1OgjmWj2qbzQAobi+DFoecueaRP2SV6KGbn4=";
  };

  ldflags = [
    "-X github.com/saucelabs/saucectl/internal/version.Version=${finalAttrs.version}"
    "-X github.com/saucelabs/saucectl/internal/version.GitCommit=${finalAttrs.version}"
  ];

  vendorHash = "sha256-n/GblPFolUD+noxGI4yZbOGdAUxM0DXtpCybS+E0k3I=";

  checkFlags = [ "-skip=^TestNewRequestWithContext$" ];

  meta = {
    description = "Command line interface for the Sauce Labs platform";
    changelog = "https://github.com/saucelabs/saucectl/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/saucelabs/saucectl";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "saucectl";
  };
})
