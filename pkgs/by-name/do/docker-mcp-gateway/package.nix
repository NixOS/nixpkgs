{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "docker-mcp-gateway";
  version = "0.42.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "mcp-gateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o3hBiK+KfN7DMj6RO7vKdPvmV+3BIwmPxAR6jLLeKog=";
  };

  vendorHash = null;

  subPackages = [ "cmd/docker-mcp" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/docker/mcp-gateway/cmd/docker/version.Version=v${finalAttrs.version}"
  ];

  installPhase = ''
    runHook preInstall

    install -D $GOPATH/bin/docker-mcp $out/libexec/docker/cli-plugins/docker-mcp

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-mcp $out/bin/docker-mcp

    runHook postInstall
  '';

  meta = {
    description = "Docker CLI plugin for managing Model Context Protocol servers";
    longDescription = ''
      Docker MCP Gateway is a CLI plugin for Docker that manages MCP (Model Context Protocol)
      servers. It acts as a gateway allowing AI applications to connect to external data sources
      and tools through the standardized MCP protocol.

      The plugin enables secure access to various services and APIs through Docker containers,
      with support for secret management and OAuth authentication flows.
    '';
    homepage = "https://github.com/docker/mcp-gateway";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.klowdo ];
    mainProgram = "docker-mcp";
  };
})
