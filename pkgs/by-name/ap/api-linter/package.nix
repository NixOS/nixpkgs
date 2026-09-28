{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "api-linter";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r1OTgsLaEZPQd7P3E7BY0YYIr93Cmeo6gH4Z24LXP3Q=";
  };

  vendorHash = "sha256-L1R0XvEn1pGy/EC/ivoUOGsyGrT5bRUkMLrGpI4VNyY=";

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
