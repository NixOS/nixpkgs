{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  playwright-driver,
  playwright-test,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.77";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "playwright-mcp";
    tag = "v${version}";
    hash = "sha256-HCi7oOW9IVouT6wahmhBjWUsY32gugudx1lOdPANmpM=";
  };

  npmDepsHash = "sha256-Spvl9UNJYPlA/4ys50diPnQhN5MwMpJU+z35eseB+EQ=";

  nativeBuildInputs = [ makeWrapper ];

  # Codex MCP smoke test (after `codex mcp add playwright-nix --env DISPLAY=:0 -- $out/bin/playwright-mcp --headless --isolated`):
  # timeout 45s codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check "Use only playwright-nix MCP tools. Navigate to https://example.com and return only the page title."
  postInstall = ''
    pkg_dir="$out/lib/node_modules/@playwright/mcp"
    rm -rf "$pkg_dir/node_modules/playwright"
    rm -rf "$pkg_dir/node_modules/playwright-core"
    ln -s ${playwright-test}/lib/node_modules/playwright "$pkg_dir/node_modules/playwright"
    ln -s ${playwright-test}/lib/node_modules/playwright-core "$pkg_dir/node_modules/playwright-core"

    wrapProgram $out/bin/playwright-mcp \
      --set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers} \
      --set-default PLAYWRIGHT_MCP_BROWSER chromium
  '';

  dontNpmBuild = true;

  passthru = {
    # Package and playwright driver versions are tightly coupled.
    skipBulkUpdate = true;
  };

  meta = {
    changelog = "https://github.com/Microsoft/playwright-mcp/releases/tag/v${version}";
    description = "Playwright MCP server";
    homepage = "https://github.com/Microsoft/playwright-mcp";
    license = lib.licenses.asl20;
    mainProgram = "playwright-mcp";
    maintainers = [ lib.maintainers.kalekseev ];
  };
}
