{
  lib,
  stdenvNoCC,

  fetchFromGitHub,
  fetchPnpmDeps,

  makeWrapper,
  nodejs,
  pnpm_11,
  pnpmConfigHook,

  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "firecrawl-mcp";
  version = "3.20.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "firecrawl";
    repo = "firecrawl-mcp-server";
    # currently no tags for latest releases
    # https://github.com/firecrawl/firecrawl-mcp-server/issues/255
    rev = "01e3b8a28ced61b4b10ab27bcbf9e59b904f887f";
    hash = "sha256-u0nUI3u1kv7imZrOqvwxcAeuumsdCGhqi7+smYtEJLs=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm_11
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 3;
    hash = "sha256-Ty6sf2Ry1CxbLDTKmIJPDzgQYx6XGPPahFD14FGyQcM=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/firecrawl-mcp

    # `pnpm build` doesn't bundle dependencies so we'll need to keep node_modules
    # - remove unnecessary files
    CI=true pnpm --ignore-scripts --prod prune
    find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete
    # - remove non-deterministic files
    rm node_modules/{.modules.yaml,.pnpm-workspace-state-v1.json}
    # - copy over node modules
    cp -r dist node_modules $out/lib/firecrawl-mcp

    # patch executable index.js just in-case
    patchShebangs $out/lib/firecrawl-mcp/dist/index.js
    # prepare an entrypoint in /bin
    makeWrapper ${lib.getExe nodejs} "$out/bin/firecrawl-mcp" --add-flags "$out/lib/firecrawl-mcp/dist/index.js"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://docs.firecrawl.dev/mcp-server";
    changelog = "https://github.com/firecrawl/firecrawl-mcp-server/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "A Model Context Protocol (MCP) server that brings Firecrawl to MCP-compatible AI agents";
    longDescription = ''
      A Model Context Protocol (MCP) server implementation that integrates
      Firecrawl for searching, scraping, and interacting with the web.
      You can either use the remote hosted Firecrawl or a self-hosted instance.

      Features:
      * Search the web and get full page content
      * Scrape any URL into clean, structured data
      * Interact with pages — click, navigate, and operate
      * Deep research with autonomous agent
      * Browser session management
      * Cloud and self-hosted support
      * Streamable HTTP support
    '';
    license = lib.licenses.mit;
    mainProgram = "firecrawl-mcp";
    maintainers = with lib.maintainers; [
      jk
    ];
    platforms = lib.platforms.all;
  };
})
