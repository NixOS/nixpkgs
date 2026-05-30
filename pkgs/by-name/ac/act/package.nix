{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  nix-update-script,
  act,
}:
buildGoModule (finalAttrs: {
  pname = "act";
  version = "0.2.88";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/nkaJlB2opuScXb8+Jo9rXdYN1Pwc+nq+T05Y4yxcCI=";
  };

  vendorHash = "sha256-z7FX2hrF4DkmHu0K9Atc76pa+PPLylimpoWhQCeF5uA=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = act;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kashw2
      miniharinn
    ];
  };
})
