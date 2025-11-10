{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  playwright-driver,
  playwright-test,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.35";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "playwright-mcp";
    tag = "v${version}";
    hash = "sha256-bF/F4dP2ri09AlQLItQwQxDAQybY2fXft4ccxSKijt8=";
  };

  npmDepsHash = "sha256-xSQCs6rJlUrdS8c580mo1/VjpcDxwHor0pdstB9VQEo=";

  postInstall = ''
    rm -r $out/lib/node_modules/@playwright/mcp/node_modules/playwright
    rm -r $out/lib/node_modules/@playwright/mcp/node_modules/playwright-core
    ln -s ${playwright-test}/lib/node_modules/playwright $out/lib/node_modules/@playwright/mcp/node_modules/playwright
    ln -s ${playwright-test}/lib/node_modules/playwright-core $out/lib/node_modules/@playwright/mcp/node_modules/playwright-core

    wrapProgram $out/bin/mcp-server-playwright \
      --set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers} \
      --set PLAYWRIGHT_MCP_BROWSER chromium \
      --run "export PLAYWRIGHT_MCP_USER_DATA_DIR=\$(mktemp -d)"
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
