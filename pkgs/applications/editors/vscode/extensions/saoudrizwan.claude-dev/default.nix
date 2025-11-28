{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-dev";
    publisher = "saoudrizwan";
    version = "3.38.3";
    hash = "sha256-LVFZlgXrnZ0X6gt+UBghvG7t6mK5R9N7X0SYb8G3alU=";
  };

  meta = {
    description = "VSCode extension providing an autonomous coding agent right in your IDE, capable of creating/editing files, executing commands, using the browser, and more with your permission every step of the way";
    downloadPage = "https://github.com/cline/cline";
    homepage = "https://github.com/cline/cline";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.matteopacini ];
  };
}
