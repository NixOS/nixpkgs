{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  playwright-driver,
  playwright-test,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.69";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "playwright-mcp";
    tag = "v${version}";
    hash = "sha256-zX9RsHVInRib69N4LkG3R4TB5qjlBirpu9BBftcr92I=";
  };

  npmDepsHash = "sha256-hc5AkUTGoXxXlDW9vPpiO23QOgANJp1lX4xoaySHoK4=";

  npmWorkspace = "packages/playwright-mcp";

  # Codex MCP smoke test (after `codex mcp add playwright-nix --env DISPLAY=:0 -- $out/bin/playwright-mcp --headless --isolated`):
  # timeout 45s codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check "Use only playwright-nix MCP tools. Navigate to https://example.com and return only the page title."
  postInstall = ''
    pkg_dir="$out/lib/node_modules/playwright-mcp-internal"
    rm -rf "$pkg_dir/node_modules/playwright"
    rm -rf "$pkg_dir/node_modules/playwright-core"
    ln -s ${playwright-test}/lib/node_modules/playwright "$pkg_dir/node_modules/playwright"
    ln -s ${playwright-test}/lib/node_modules/playwright-core "$pkg_dir/node_modules/playwright-core"

    # Workspace symlinks point to a packages/ tree that npmInstallHook does not
    # ship; npm hoisted the workspace contents directly into playwright-mcp-internal.
    rm "$pkg_dir/node_modules/@playwright/mcp"
    rm "$pkg_dir/node_modules/@playwright/mcp-extension"
    rm "$pkg_dir/node_modules/playwright-cli"
    rm "$pkg_dir/node_modules/.bin/playwright-mcp"

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
