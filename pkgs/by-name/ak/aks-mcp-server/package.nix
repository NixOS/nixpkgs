{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, azure-cli
, kubectl
, stdenv
}:

buildGoModule rec {
  pname = "aks-mcp-server";
  version = "unstable-2025-01-16";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "aks-mcp";
    rev = "a653c33a9847d9ed9e4b12623245f9f9746acea9";
    hash = "sha256-pwwMyPRpyc89BQ9c1B8dxWyI06QX0iHNiH79xvilMlQ=";
  };

  vendorHash = "sha256-+T2g++tn7MNcWF9AIWdQY9JBU1CMbBuZZKbZQ5aAv7Y=";

  subPackages = [ "cmd/aks-mcp" ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # Disable CGO and set environment variables
  CGO_ENABLED = "0";
  
  # Set build environment to use withoutebpf tags
  preBuild = ''
    export CGO_ENABLED=0
    export GOOS=${if stdenv.isDarwin then "darwin" else "linux"}
    export GOARCH=${if stdenv.hostPlatform.isAarch64 then "arm64" else "amd64"}
  '';

  # Use buildPhase to control the build with tags
  buildPhase = ''
    runHook preBuild
    
    echo "Building with CGO_ENABLED=0 and withoutebpf tags..."
    go build -tags withoutebpf -o $GOPATH/bin/aks-mcp ./cmd/aks-mcp
    
    runHook postBuild
  '';

  ldflags = [
    "-s"
    "-w" 
    "-X github.com/Azure/aks-mcp/internal/version.GitVersion=v${version}"
    "-X github.com/Azure/aks-mcp/internal/version.GitCommit=${src.rev}"
    "-X github.com/Azure/aks-mcp/internal/version.GitTreeState=clean"
    "-X github.com/Azure/aks-mcp/internal/version.BuildDate=1970-01-01T00:00:00Z"
  ];

  checkFlags = [
    "-skip=TestAzure"
    "-skip=TestExecutor"
    "-skip=TestClient"
  ];

  postInstall = ''
    mv $out/bin/aks-mcp $out/bin/aks-mcp-server
    
    wrapProgram $out/bin/aks-mcp-server \
      --prefix PATH : ${lib.makeBinPath [ azure-cli kubectl ]}
  '';

  meta = with lib; {
    description = "Model Context Protocol server for Azure Kubernetes Service";
    longDescription = ''
      The AKS-MCP server enables AI assistants to interact with Azure Kubernetes
      Service clusters through the Model Context Protocol. It translates natural
      language requests into AKS operations and provides cluster information,
      network details, and resource management capabilities.
    '';
    homepage = "https://github.com/Azure/aks-mcp";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix; # Now supports both Linux and macOS with withoutebpf
    mainProgram = "aks-mcp-server";
  };
}
