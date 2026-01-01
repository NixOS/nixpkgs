{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  playwright-driver,
  playwright-test,
}:
<<<<<<< HEAD
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.53";
=======

buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.34";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "playwright-mcp";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-TuXdvaPa5732NTZ5Fchjr5pXsURYxsnrjf6CS1qlkOA=";
  };

  npmDepsHash = "sha256-Rdtc8rWyBmWmC1qy7TetaAdb1OFG6PdB5/2xQe8MwUg=";
=======
    hash = "sha256-SGSzX41D9nOTsGiU16tRFXgarWgePRsNWIcEnNGH0lQ=";
  };

  npmDepsHash = "sha256-+6HmuR1Z5cJkoZq/vsFq6wNsYpZeDS42wwmh3hEgJhM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstall = ''
    rm -r $out/lib/node_modules/@playwright/mcp/node_modules/playwright
    rm -r $out/lib/node_modules/@playwright/mcp/node_modules/playwright-core
    ln -s ${playwright-test}/lib/node_modules/playwright $out/lib/node_modules/@playwright/mcp/node_modules/playwright
    ln -s ${playwright-test}/lib/node_modules/playwright-core $out/lib/node_modules/@playwright/mcp/node_modules/playwright-core

    wrapProgram $out/bin/mcp-server-playwright \
<<<<<<< HEAD
      --set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers} \
      --set-default PLAYWRIGHT_MCP_BROWSER chromium \
      --run 'if [ -z "$PLAYWRIGHT_MCP_USER_DATA_DIR" ]; then PLAYWRIGHT_MCP_USER_DATA_DIR="$(mktemp -d -t mcp-pw-XXXXXX)"; export PLAYWRIGHT_MCP_USER_DATA_DIR; trap "rm -rf \"$PLAYWRIGHT_MCP_USER_DATA_DIR\"" EXIT; fi'
  '';

  dontNpmBuild = true;

=======
      --set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers}
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
