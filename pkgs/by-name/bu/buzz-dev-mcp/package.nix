{
  buzz-cli,
  lib,
  runCommand,
  rustPlatform,
  bash,
  git,
  makeBinaryWrapper,
  ripgrep,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buzz-dev-mcp";
  # Shares the Buzz workspace source and Cargo lockfile with buzz-cli.
  inherit (buzz-cli)
    version
    src
    cargoHash
    preBuild
    env
    ;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ makeBinaryWrapper ];
  nativeCheckInputs = [
    bash
    git
    ripgrep
  ];

  cargoBuildFlags = [ "--package=buzz-dev-mcp" ];
  cargoTestFlags = [ "--package=buzz-dev-mcp" ];

  # Some tests expand `~` against a writable HOME (block/buzz#8035).
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    wrapProgram $out/bin/buzz-dev-mcp \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          git
          ripgrep
        ]
      }
  '';

  passthru.tests.mcp-initialize =
    runCommand "buzz-dev-mcp-mcp-initialize" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
      ''
        export HOME=$TMPDIR
        echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"0"}}}' \
          | buzz-dev-mcp > reply.json
        grep -F '"serverInfo":{"name":"buzz-dev-mcp"' reply.json
        touch $out
      '';

  meta = {
    description = "Model Context Protocol (MCP) server for Buzz developers and AI coding agents";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "buzz-dev-mcp";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
