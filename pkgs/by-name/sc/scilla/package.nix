{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "scilla";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "scilla";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zeEsxmj1APc/vsKRTrdkVLJoILr6Gx9i0VSQ+dTLlGM=";
  };

  vendorHash = "sha256-nI79Gx6Vs7wyqK9pCSbsFGmKBsqcmCNk2LpQ5fi79h4=";

  ldflags = [
    "-w"
    "-s"
  ];

  checkFlags = [
    # requires network access
    "-skip=TestIPToHostname"
  ];

  meta = {
    description = "Information gathering tool for DNS, ports and more";
    mainProgram = "scilla";
    homepage = "https://github.com/edoardottt/scilla";
    changelog = "https://github.com/edoardottt/scilla/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
