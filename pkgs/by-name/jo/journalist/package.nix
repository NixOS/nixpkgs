{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "journalist";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "journalist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3MnkndG2c4P3oprIRbzj26oAutEmAgsUx8mjlaDLrkI=";
  };

  vendorHash = "sha256-2EJ96dhhU7FZxMkHOmQo79WCHu8U1AGgFf47FIuQdek=s";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mrusme/journalist/journalistd.VERSION=${finalAttrs.version}"
  ];

  meta = {
    description = "RSS aggregator";
    homepage = "https://github.com/mrusme/journalist";
    changelog = "https://github.com/mrusme/journalist/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "journalist";
  };
})
