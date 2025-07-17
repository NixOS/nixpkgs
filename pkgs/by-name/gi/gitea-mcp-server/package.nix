{
  lib,
  buildGoModule,
  fetchFromGitea,
}:
buildGoModule (finalAttrs: {
  pname = "gitea-mcp-server";
  version = "0.2.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "gitea-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZUnpE25XIYzSwdEilzXnhqGR676iBQcR2yiT3jhJApc=";
  };

  vendorHash = "sha256-u9jIjrbDUhnaaeBET+pKQTKhaQLUeQvKOXSBfS0vMJM=";

  subPackages = [ "." ];

  doCheck = false; # no test

  postInstall = ''
    install -Dm644 README.md LICENSE -t $out/share/doc/gitea-mcp-server
  '';

  meta = {
    description = "Gitea Model Context Protocol (MCP) Server";
    longDescription = ''
      The Gitea MCP Server is a Model Context Protocol (MCP) server that provides
      seamless integration with Gitea APIs, enabling advanced automation and
      interaction capabilities for developers and tools.

      This server allows LLMs to interact with Gitea repositories, issues, pull
      requests, and other Gitea features through structured API interactions.
    '';
    homepage = "https://gitea.com/gitea/gitea-mcp";
    license = lib.licenses.mit;
    mainProgram = "gitea-mcp";
    maintainers = with lib.maintainers; [ connerohnesorge ];
  };
})
