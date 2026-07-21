{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  geckodriver,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "firefox-devtools-mcp";
  version = "0.9.9";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "firefox-devtools-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bz6LkiUbgu81OnPv6xegmo7EYVgGJdlbB5HZsW4QO/Q=";
  };

  npmDepsHash = "sha256-JnAivSiThEm+EPm6gY08zQfD/aaF2sLfz6YSfsle9uE=";

  # 0.9.9 ships a stale hardcoded server version (0.7.1) in constants.ts; upstream switched to
  # build-time injection right after release (Bug 2050918), so this substitution should be dropped
  # once that fix lands in a tagged release.
  postPatch = ''
    substituteInPlace src/config/constants.ts \
      --replace-fail "'0.7.1'" "'${finalAttrs.version}'"
  '';

  nativeBuildInputs = [ makeWrapper ];

  # The `geckodriver` npm dependency's install script downloads a prebuilt binary from the network,
  # which is unavailable in the sandbox. The server locates geckodriver on PATH first (see
  # src/firefox/core.ts), so skip the install scripts and provide geckodriver from nixpkgs via the
  # wrapper below.
  npmFlags = [ "--ignore-scripts" ];

  # `npm run build` (tsup) emits dist/index.js, the package's bin entry point.
  postInstall = ''
    wrapProgram $out/bin/firefox-devtools-mcp \
      --prefix PATH : ${lib.makeBinPath [ geckodriver ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Model Context Protocol server for Firefox DevTools automation";
    longDescription = ''
      A Model Context Protocol (MCP) server that automates Firefox via WebDriver BiDi.
      It works with MCP clients such as Claude Code, Claude Desktop, Cursor and Cline,
      exposing tools to navigate pages, take snapshots, inspect the DOM, capture network requests
      and console messages, take screenshots and more.

      A local Firefox installation is required at runtime.
    '';
    homepage = "https://github.com/mozilla/firefox-devtools-mcp";
    changelog = "https://github.com/mozilla/firefox-devtools-mcp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ philiptaron ];
    mainProgram = "firefox-devtools-mcp";
    platforms = lib.platforms.unix;
  };
})
