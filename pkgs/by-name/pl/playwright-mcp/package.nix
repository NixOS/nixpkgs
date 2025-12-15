{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  playwright-driver,
  playwright-test,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.52";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "playwright-mcp";
    tag = "v${version}";
    hash = "sha256-01y9qIr0T0CYfswqFK7AXx3AeYwzhhy5bY5S/PFqtJA=";
  };

  npmDepsHash = "sha256-fWQ9fsjsoQ142I0OG5i5PtsC0iN9IBoSehqzH00p+ck=";

  postInstall = ''
    rm -r $out/lib/node_modules/@playwright/mcp/node_modules/playwright
    rm -r $out/lib/node_modules/@playwright/mcp/node_modules/playwright-core
    ln -s ${playwright-test}/lib/node_modules/playwright $out/lib/node_modules/@playwright/mcp/node_modules/playwright
    ln -s ${playwright-test}/lib/node_modules/playwright-core $out/lib/node_modules/@playwright/mcp/node_modules/playwright-core

    wrapProgram $out/bin/mcp-server-playwright \
      --set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers} \
      --set-default PLAYWRIGHT_MCP_BROWSER chromium \
      --run 'if [ -z "$PLAYWRIGHT_MCP_USER_DATA_DIR" ]; then PLAYWRIGHT_MCP_USER_DATA_DIR="$(mktemp -d -t mcp-pw-XXXXXX)"; export PLAYWRIGHT_MCP_USER_DATA_DIR; trap "rm -rf \"$PLAYWRIGHT_MCP_USER_DATA_DIR\"" EXIT; fi'
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
    mainProgram = "mcp-server-playwright";
    maintainers = [ lib.maintainers.kalekseev ];
  };
}
