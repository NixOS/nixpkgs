{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "galah";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "0x4D31";
    repo = "galah";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dGUsZs7rZsCwtwP4WI5JWWC/DyXb+5hQSMAXLRM+PZg=";
  };

  vendorHash = "sha256-ZyO2PJgc4KYltiiYMOwxVwTuB+yjtxC7BP1QMrVwEQ4=";

  ldflags = [ "-s" ];

  meta = {
    description = "LLM-powered web honeypot using the OpenAI API";
    homepage = "https://github.com/0x4D31/galah";
    changelog = "https://github.com/0x4D31/galah/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "galah";
  };
})
