{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  azure-cli,
  makeWrapper,
}:

let
  version = "3.0.0-beta.10";
  srcs = {
    x86_64-linux = {
      url = "https://github.com/microsoft/mcp/releases/download/Azure.Mcp.Server-${version}/Azure.Mcp.Server-linux-x64-native.zip";
      hash = "sha256-2wrpyTVunT54dYD1ascVDRTW2AN5NpoV+q3UUt5dQSg=";
    };
    aarch64-linux = {
      url = "https://github.com/microsoft/mcp/releases/download/Azure.Mcp.Server-${version}/Azure.Mcp.Server-linux-arm64.zip";
      hash = "sha256-K1QRpj5/RzZx2mrmtnB5lGX9CoaAC+pRVGqqHtXWncY=";
    };
    x86_64-darwin = {
      url = "https://github.com/microsoft/mcp/releases/download/Azure.Mcp.Server-${version}/Azure.Mcp.Server-osx-x64.zip";
      hash = "sha256-ebT6sipbA7IdGx98kF/8GLpHL1fVSVqnmL4rEwsa43k=";
    };
    aarch64-darwin = {
      url = "https://github.com/microsoft/mcp/releases/download/Azure.Mcp.Server-${version}/Azure.Mcp.Server-osx-arm64.zip";
      hash = "sha256-33rg+fnIB/VJZbVKTP7b8829BbcDnfnaYFMOyPLFzEw=";
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

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ./azmcp $out/bin/azure-mcp

    wrapProgram $out/bin/azure-mcp \
      --prefix PATH : ${lib.makeBinPath [ azure-cli ]}

    runHook postInstall
  '';

  meta = {
    description = "Model Context Protocol server for Azure services";
    longDescription = ''
      The Azure MCP Server implements the Model Context Protocol (MCP)
      specification to create a seamless connection between AI agents and
      Azure services. It provides 321+ tools for interacting with Azure
      resources including storage, compute, databases, and more.
    '';
    homepage = "https://github.com/microsoft/mcp";
    changelog = "https://github.com/microsoft/mcp/blob/Azure.Mcp.Server-${version}/servers/Azure.Mcp.Server/CHANGELOG.md";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.attrNames srcs;
    mainProgram = "azure-mcp";
    maintainers = with lib.maintainers; [ sheeeng ];
  };
}
