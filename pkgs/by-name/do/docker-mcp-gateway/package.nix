{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "docker-mcp-gateway";
  version = "v0.36.0";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "mcp-gateway";
    rev = "6c7ffeea484ed3e301cd20eb6b5b38c162895f33";
    hash = "sha256-rcEoWT4egN/Mv4Fqm9NVzJG16+Cufp6B3u+7JPn673g=";
  };

  vendorHash = null;

  subPackages = [ "cmd/docker-mcp" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/docker/mcp-gateway/cmd/docker/version.Version=v${version}"
  ];

  installPhase = ''
    runHook preInstall

    install -D $GOPATH/bin/docker-mcp $out/libexec/docker/cli-plugins/docker-mcp

    mkdir -p $out/bin
    ln -s $out/libexec/docker/cli-plugins/docker-mcp $out/bin/docker-mcp

    runHook postInstall
  '';

  meta = with lib; {
    description = "Docker MCP Gateway - CLI plugin for managing Model Context Protocol servers";
    longDescription = ''
      Docker MCP Gateway is a CLI plugin for Docker that manages MCP (Model Context Protocol)
      servers. It acts as a gateway allowing AI applications to connect to external data sources
      and tools through the standardized MCP protocol.

      The plugin enables secure access to various services and APIs through Docker containers,
      with support for secret management and OAuth authentication flows.
    '';
    homepage = "https://github.com/docker/mcp-gateway";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "docker-mcp";
  };
}
