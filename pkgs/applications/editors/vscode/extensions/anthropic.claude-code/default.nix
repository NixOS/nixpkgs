{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-code";
    publisher = "anthropic";
    version = "1.0.79";
    hash = "sha256-/hAIBbQCuvV9PkKZxDLZ8UxHQ9zJLhl09sg6VHXBdwI=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/anthropic.claude-code";
    description = "Claude Code for VS Code: Harness the power of Claude Code without leaving your IDE";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code";
    homepage = "https://claude.ai/code";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.flacks ];
  };
}
