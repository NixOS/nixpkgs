{
  lib,
  buildGo126Module,
  fetchFromGitea,
}:

buildGo126Module (finalAttrs: {
  pname = "gitea-mcp-server";
  version = "1.4.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "gitea-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K3jEuFrGm4J1atMOtBIxSlzzi6NtrcxG0sIL0uzrUW8=";
  };

  vendorHash = "sha256-BYHcV5WSklGqdeTN7S2AMtscJDCA/8n1gEOgLzr9Gmk=";

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
