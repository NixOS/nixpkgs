{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ktea";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "jonas-grgt";
    repo = "ktea";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TWz1YKnwfnj+smZog4vCz7SFW3rBMaeI3G+9zW6A7fQ=";
  };

  vendorHash = "sha256-jecT3Vx703LYQ8A5hEnaZczkeZxBKaojERgj9OfBBS4=";

  subPackages = [ "cmd/ktea" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kafka TUI client";
    homepage = "https://github.com/jonas-grgt/ktea";
    changelog = "https://github.com/jonas-grgt/ktea/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "ktea";
  };
})
