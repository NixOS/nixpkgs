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
  # nixpkgs-update: no auto update
  version = "0.0.84";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "playwright-mcp";
    tag = "v${version}";
    hash = "sha256-ijUhAxZls2QQkwNUtO7Ip51h+/I4OBqj5V7WCm8cU84=";
  };

  npmDepsHash = "sha256-Z0Ab9kB1tow5//Y3FpQ6JxzITyqtP2BksPVp0mIoX1c=";

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
      --set-default PLAYWRIGHT_MCP_BROWSER chromium \
      --run 'if [ -z "$PLAYWRIGHT_MCP_USER_DATA_DIR" ]; then export PLAYWRIGHT_MCP_ISOLATED=1; fi'
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
