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
  version = "0.0.20";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "aks-mcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K0BVDH0HT4kQBGMpVDtLihDCPlpcVpdGEF7f5DY8SvQ=";
  };

  vendorHash = "sha256-EdDiLibw3OXtTmAaD6PIi6xiW7+x8TUeAezdjpu8IjY=";

  subPackages = [ "cmd/aks-mcp" ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  env.CGO_ENABLED = "0";

  tags = lib.optionals stdenv.hostPlatform.isDarwin [ "withoutebpf" ];

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

  # ebpf is a linux only feature
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export GOFLAGS="$GOFLAGS -tags=withoutebpf"
  '';

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
    platforms = lib.platforms.unix;
    mainProgram = "aks-mcp";
  };
})
