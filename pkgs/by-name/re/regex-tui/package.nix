{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "regex-tui";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "vitor-mariano";
    repo = "regex-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iBlvgFEjfyVL5kfI02UZ+gCLLSNMQte5xU9kcNby4GU=";
  };

  vendorHash = "sha256-eYeMY+XYHgeFF18lKXhvJV7Xp2U/1afVETbJgaMJ7t8=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visualize regular expressions right in your terminal";
    homepage = "https://github.com/vitor-mariano/regex-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "regex-tui";
  };
})
