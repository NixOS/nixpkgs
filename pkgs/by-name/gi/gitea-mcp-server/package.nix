{
  lib,
  buildGo127Module,
  fetchFromGitea,
}:

buildGo127Module (finalAttrs: {
  pname = "gitea-mcp-server";
  version = "1.8.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "gitea-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m+4ktYG8rdGRlZatlJzA485X5bSaDlKzSm4mi3fPxoA=";
  };

  vendorHash = "sha256-Jv3blO27q+AKC//OqtaTInOXbvxXlKzaYx9Aesabh30=";

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
