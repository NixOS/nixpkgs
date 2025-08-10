{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  playwright-driver,
  playwright-test,
}:

buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.31";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "playwright-mcp";
    tag = "v${version}";
    hash = "sha256-Hw4OUZCHoquX6Ixv7GlsHcKxqOdJEQYfuDPzqYkVNAk=";
  };

  npmDepsHash = "sha256-70/t/mgSBwMv9C3VusbjIMMyy3e3npxQLXqKbdL9xa4=";

  postInstall = ''
    rm -r $out/lib/node_modules/@playwright/mcp/node_modules/playwright
    rm -r $out/lib/node_modules/@playwright/mcp/node_modules/playwright-core
    ln -s ${playwright-test}/lib/node_modules/playwright $out/lib/node_modules/@playwright/mcp/node_modules/playwright
    ln -s ${playwright-test}/lib/node_modules/playwright-core $out/lib/node_modules/@playwright/mcp/node_modules/playwright-core

    wrapProgram $out/bin/mcp-server-playwright \
      --set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers}
  '';

  passthru = {
    # Package and playwright driver versions are tightly coupled.
    skipBulkUpdate = true;
  };

  meta = {
    changelog = "https://github.com/Microsoft/playwright-mcp/releases/tag/v${version}";
    description = "Playwright MCP server";
    homepage = "https://github.com/Microsoft/playwright-mcp";
    license = lib.licenses.asl20;
    mainProgram = "mcp-server-playwright";
    maintainers = [ lib.maintainers.kalekseev ];
  };
}
