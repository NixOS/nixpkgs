{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  azure-cli,
  makeWrapper,
}:

let
  version = "2.0.0-beta.19";
  srcs = {
    x86_64-linux = {
      url = "https://github.com/microsoft/mcp/releases/download/Azure.Mcp.Server-${version}/Azure.Mcp.Server-linux-x64-native.zip";
      hash = "sha256-LU1YvRSPMRyuoBaho6ZHJjYv8v2SF6XyPldE0StItTo=";
    };
    aarch64-linux = {
      url = "https://github.com/microsoft/mcp/releases/download/Azure.Mcp.Server-${version}/Azure.Mcp.Server-linux-arm64.zip";
      hash = "sha256-fDqKAC06XAd/ET49Tcfs50WKZK9jYgT7EG9LPpQo4BU=";
    };
    x86_64-darwin = {
      url = "https://github.com/microsoft/mcp/releases/download/Azure.Mcp.Server-${version}/Azure.Mcp.Server-osx-x64.zip";
      hash = "sha256-jKTVdiYMZrnpdsXrKI7lfsOoKzjz1Z1OS/doJxQZ1Bc=";
    };
    aarch64-darwin = {
      url = "https://github.com/microsoft/mcp/releases/download/Azure.Mcp.Server-${version}/Azure.Mcp.Server-osx-arm64.zip";
      hash = "sha256-gEpIxioXcx4AXSuinWFM1D5BkVGOzIoGC/1plNyBFgU=";
    };
  };
  unavailable = throw "azure-mcp package is not available for this platform.";
  src = fetchzip {
    inherit (srcs.${stdenv.hostPlatform.system} or unavailable) url hash;
    stripRoot = false;
  };
in
stdenv.mkDerivation {
  pname = "azure-mcp";
  inherit version src;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
  ];

  # libmsalruntime.so is an optional library for interactive browser-based
  # authentication. Its GTK/WebKit dependencies are not needed since the server
  # authenticates via Azure CLI (az login). Use wildcard to ignore all its
  # transitive dependencies on x86_64-linux.
  autoPatchelfIgnoreMissingDeps = [ "*" ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/share/azure-mcp

    # Install the binary and supporting files.
    cp -r ./* $out/share/azure-mcp/
    chmod +x $out/share/azure-mcp/azmcp

    # Add azure-cli wrapper to PATH environment variable.
    makeWrapper $out/share/azure-mcp/azmcp $out/bin/azure-mcp \
      --prefix PATH : ${lib.makeBinPath [ azure-cli ]}

    runHook postInstall
  '';

  meta = {
    description = "Model Context Protocol server for Azure services";
    longDescription = ''
      The Azure MCP Server implements the Model Context Protocol (MCP)
      specification to create a seamless connection between AI agents and
      Azure services. It provides 221+ tools for interacting with Azure
      resources including storage, compute, databases, and more.
    '';
    homepage = "https://github.com/microsoft/mcp";
    changelog = "https://github.com/microsoft/mcp/blob/Template.Mcp.Server-${version}/servers/Azure.Mcp.Server/CHANGELOG.md";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.attrNames srcs;
    mainProgram = "azure-mcp";
    maintainers = with lib.maintainers; [ sheeeng ];
  };
}
