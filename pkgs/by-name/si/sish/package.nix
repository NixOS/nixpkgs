{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  sish,
}:

buildGoModule (finalAttrs: {
  pname = "sish";
  version = "2.21.1";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = "sish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AHMga+5JLowaBJ2BvCWWamSrQNem4unIwuxd8D8vDsQ=";
  };

  vendorHash = "sha256-1MojbM5MsJzhrUWLyQuTw7rBvDdAaQonpkCpuJz9EHA=";

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
