{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  azure-cli,
  kubectl,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "aks-mcp-server";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "aks-mcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3G7IDHDY3HfjGYM8aKK4Egey1/urDVeWv99PJcCaiSo=";
  };

  vendorHash = "sha256-aMs7vABZwRPPIaP6BdTau1oFfGqnzYt8wxUk2mQSVlE=";

  subPackages = [ "cmd/aks-mcp" ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  # Disable CGO and set environment variables
  env.CGO_ENABLED = "0";

  tags = [ "withoutebpf" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Azure/aks-mcp/internal/version.GitVersion=${finalAttrs.version}"
    "-X github.com/Azure/aks-mcp/internal/version.GitCommit=${finalAttrs.src.rev}"
    "-X github.com/Azure/aks-mcp/internal/version.GitTreeState=clean"
    "-X github.com/Azure/aks-mcp/internal/version.BuildDate=1970-01-01T00:00:00Z"
  ];

  checkFlags = [
    "-skip=TestAzure"
    "-skip=TestExecutor"
    "-skip=TestClient"
  ];

  postInstall = ''


    wrapProgram $out/bin/aks-mcp \
      --set-default AKS_MCP_COLLECT_TELEMETRY false \
      --prefix PATH : ${
        lib.makeBinPath [
          azure-cli
          kubectl
        ]
      }
  '';

  meta = {
    description = "Model Context Protocol server for Azure Kubernetes Service";
    longDescription = ''
      The AKS-MCP server enables AI assistants to interact with Azure Kubernetes
      Service clusters through the Model Context Protocol. It translates natural
      language requests into AKS operations and provides cluster information,
      network details, and resource management capabilities.
    '';
    homepage = "https://github.com/Azure/aks-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ priyaananthasankar ];
    platforms = lib.platforms.unix; # Now supports both Linux and macOS with withoutebpf
    mainProgram = "aks-mcp";
  };
})
