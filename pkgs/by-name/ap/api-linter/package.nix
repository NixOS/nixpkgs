{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "api-linter";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yx4UTxFJSc+tsA2u6IiSlzV9H7occ2qKtCm7zwv5PaA=";
  };

  vendorHash = "sha256-TiZRts1ruC0R5DQ5at7Z1c+zuGpD0f3D89X2b1gXA5s=";

  subPackages = [ "cmd/api-linter" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Linter for APIs defined in protocol buffers";
    homepage = "https://github.com/googleapis/api-linter/";
    changelog = "https://github.com/googleapis/api-linter/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xrelkd ];
    mainProgram = "api-linter";
  };
})
