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
  version = "0.2.92";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ai8DcpQHzXsjN7FRgXpH7str0nvXPPpMYdEL4pWABv0=";
  };

  vendorHash = "sha256-swbESCLfvFlfpzVDhECGbwmrs8g3GgFisLJXfraytro=";

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
