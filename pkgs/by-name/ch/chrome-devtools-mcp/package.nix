{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  installAgentSkills,
  nodejs,
  nix-update-script,
}:

# Packaging notes:
# - The upstream repo builds via Chromium's gn/ninja toolchain and pulls
#   dependencies with `git submodule` + gclient sync, which cannot run in
#   the nix sandbox. The npm tarball is the official release artifact
#   (release-please) and ships a fully bundled output with zero runtime
#   dependencies, so installing it directly is the practical option
#   (same approach as context-mode).
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chrome-devtools-mcp";
  version = "1.13.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-${finalAttrs.version}.tgz";
    hash = "sha256-kVjEtKh5LLUirkb3buqpSRzgRhajrpcimhYnfgKkrqQ=";
  };

  sourceRoot = "package";

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    installAgentSkills
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/chrome-devtools-mcp
    # out/Default/gen/ (bundled output) + package.json (type:module ESM
    # context); skills/ is picked up automatically by the installAgentSkills
    # setup hook.
    cp -r out package.json $out/lib/chrome-devtools-mcp/

    # Both entry points declared in upstream package.json:
    #   chrome-devtools-mcp: MCP server (stdio)
    #   chrome-devtools: CLI / daemon
    for bin in chrome-devtools-mcp chrome-devtools; do
      makeWrapper ${lib.getExe nodejs} $out/bin/$bin \
        --add-flags "$out/lib/chrome-devtools-mcp/out/Default/gen/src/bin/$bin.js"
    done

    runHook postInstall
  '';

  postFixup = ''
    # Silence the upstream update check: it spawns a detached child that
    # queries the npm registry and writes to ~/.cache, and its only output
    # for nix users is a misleading "npm install to update" hint. Version
    # management is handled by this package's updateScript instead.
    for bin in chrome-devtools-mcp chrome-devtools; do
      wrapProgram $out/bin/$bin --set CHROME_DEVTOOLS_MCP_NO_UPDATE_CHECKS 1
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server providing Chrome DevTools features to AI agents";
    longDescription = ''
      Official MCP (Model Context Protocol) server maintained by the Chrome
      DevTools team. It lets AI agents launch a real Chrome instance and
      interact with web pages through DevTools APIs: take screenshots, click,
      fill forms, evaluate JavaScript, capture network traces and performance
      data, and emulate devices.
    '';
    homepage = "https://github.com/ChromeDevTools/chrome-devtools-mcp";
    changelog = "https://github.com/ChromeDevTools/chrome-devtools-mcp/releases/tag/chrome-devtools-mcp-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ luochen1990 ];
    mainProgram = "chrome-devtools-mcp";
    platforms = lib.platforms.unix;
  };
})
