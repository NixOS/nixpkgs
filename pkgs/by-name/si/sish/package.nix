{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  sish,
}:

buildGoModule (finalAttrs: {
  pname = "sish";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = "sish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8C4Xh9OX5pmaQ12Guu3y/jw8nIfy6DV0nduAH6hlImM=";
  };

  vendorHash = "sha256-U+gMlfDTEt9//SRLJA5yx/VZhwFGuMpTCnCfw9Nck+0=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/antoniomika/sish/cmd.Commit=${finalAttrs.src.rev}"
    "-X=github.com/antoniomika/sish/cmd.Date=1970-01-01"
    "-X=github.com/antoniomika/sish/cmd.Version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = sish;
    };
  };

  meta = {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    changelog = "https://github.com/antoniomika/sish/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sish";
  };
})
