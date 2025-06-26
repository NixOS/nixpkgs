{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "picocrypt-cli";
  version = "1.48";

  src = fetchFromGitHub {
    owner = "Picocrypt";
    repo = "CLI";
    tag = finalAttrs.version;
    hash = "sha256-A/04tuDwB2nAGWOWNEPt87lwAR/5Co/IjjV7xIcRxUo=";
  };

  sourceRoot = "${finalAttrs.src.name}/picocrypt";
  vendorHash = "sha256-iVbfvV3BqK40uU9kQaqgIsHmX8i7w1M1MIxnknDP6AM=";

  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 1;

  meta = {
    description = "Command-line interface for Picocrypt";
    homepage = "https://github.com/Picocrypt/CLI";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      arthsmn
      ryand56
    ];
    mainProgram = "picocrypt";
  };
})
