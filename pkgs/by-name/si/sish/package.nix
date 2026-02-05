{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
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

  __darwinAllowLocalNetworking = true;

  vendorHash = "sha256-1MojbM5MsJzhrUWLyQuTw7rBvDdAaQonpkCpuJz9EHA=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/antoniomika/sish/cmd.Commit=${finalAttrs.src.tag}"
    "-X=github.com/antoniomika/sish/cmd.Date=1970-01-01"
    "-X=github.com/antoniomika/sish/cmd.Version=${finalAttrs.src.tag}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    changelog = "https://github.com/antoniomika/sish/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sish";
  };
})
