{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "picocrypt-cli";
  version = "1.48";

  src = fetchFromGitHub {
    owner = "Picocrypt";
    repo = "CLI";
    tag = version;
    hash = "sha256-A/04tuDwB2nAGWOWNEPt87lwAR/5Co/IjjV7xIcRxUo=";
  };

  sourceRoot = "${src.name}/picocrypt";
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
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "picocrypt";
  };
}
