{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  sish,
}:

buildGoModule (finalAttrs: {
  pname = "sish";
  version = "2.22.1";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = "sish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sLryMoGnxTinMsf4DXyM37MjZ5TaJI+ldYxKiCB6ny0=";
  };

  vendorHash = "sha256-3Imp9g0/Ory7ECw4pkrIltau9G1Aw3uRP5A+zWCz0mE=";

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
