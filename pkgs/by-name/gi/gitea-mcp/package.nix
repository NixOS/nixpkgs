{
  lib,
  buildGoModule,
  fetchFromGitea,
}:

buildGoModule rec {
  pname = "gitea-mcp";
  version = "0.2.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "gitea-mcp";
    rev = "v${version}";
    hash = "sha256-ZUnpE25XIYzSwdEilzXnhqGR676iBQcR2yiT3jhJApc=";
  };

  vendorHash = "sha256-u9jIjrbDUhnaaeBET+pKQTKhaQLUeQvKOXSBfS0vMJM=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  meta = {
    description = "Interact with Gitea instances with MCP";
    homepage = "https://gitea.com/gitea/gitea-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ etwas ];
    mainProgram = "gitea-mcp";
  };
}
