{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ktea";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "jonas-grgt";
    repo = "ktea";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xx99mAMK0KFHL4uAGLcD+FYZPqImVkQCJoIywYMGsFg=";
  };

  vendorHash = "sha256-eNM1F2u4ORkqyV0NumRQSUjJZg7Bdz7S+sWJO/bgEx4=";

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
