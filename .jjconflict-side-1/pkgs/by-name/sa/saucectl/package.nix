{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "saucectl";
  version = "0.183.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "saucelabs";
    repo = "saucectl";
    rev = "refs/tags/v${version}";
    hash = "sha256-43X+GBm0pasSSwBB8Q2V8Vr2SjFInHaNMvUNVqD0/pI=";
  };

  ldflags = [
    "-X github.com/saucelabs/saucectl/internal/version.Version=${version}"
    "-X github.com/saucelabs/saucectl/internal/version.GitCommit=${version}"
  ];

  vendorHash = "sha256-SQveLJzicQSCBwfV3eZyXkArO1wLly1cCvol9PbeEV0=";

  checkFlags = [ "-skip=^TestNewRequestWithContext$" ];

  meta = {
    description = "Command line interface for the Sauce Labs platform";
    changelog = "https://github.com/saucelabs/saucectl/releases/tag/v${version}";
    homepage = "https://github.com/saucelabs/saucectl";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "saucectl";
  };
}
