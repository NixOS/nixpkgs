{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "buttplug-mcp";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "ConAcademy";
    repo = "buttplug-mcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C4ZPTO+Gh6g19BrqHugSCF74aAZ888XRTk1AzNpEBok=";
  };

  vendorHash = "sha256-EoLv7HpdAyEM83m/DTgu9jMh0Nn+v8b2buIavQFJbnY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Buttplug.io Model Context Protocol (MCP) Server";
    homepage = "https://github.com/ConAcademy/buttplug-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "buttplug-mcp";
  };
})
