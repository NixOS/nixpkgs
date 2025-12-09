{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcp-k8s-go";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "strowk";
    repo = "mcp-k8s-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wGaQXyOCaXnc5pZobdLk2bQLkJfNHXIcw/SRn1dBJ3A=";
  };

  vendorHash = "sha256-WULy61Ntra9Jz4fhSVOzftzWyQxvPFyBfjuKlKTORqI=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "MCP server connecting to Kubernetes";
    homepage = "https://github.com/strowk/mcp-k8s-go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "mcp-k8s-go";
  };
})
