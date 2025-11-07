{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gatus-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0acFtEIZCZMXDpYVW26u6DDwymKNJ1l9urNMgFlVXrU=";
  };

  vendorHash = "sha256-LNcGNPupeyztuq5hpyDt/tIxMEI/yemhFhJHsh3ZzOU=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Client for Gatus, an automated developer-oriented status page";
    homepage = "https://github.com/TwiN/gatus-cli";
    changelog = "https://github.com/TwiN/gatus-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.giorgiga ];
    mainProgram = "gatus-cli";
  };
})
