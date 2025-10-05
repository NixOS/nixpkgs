{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-dev";
    publisher = "saoudrizwan";
    version = "3.32.5";
    hash = "sha256-5db3CCXzugrua29BKRTH8XG4/2lGkZU+6dw3YS9DPT4=";
  };

  meta = {
    description = "VSCode extension providing an autonomous coding agent right in your IDE, capable of creating/editing files, executing commands, using the browser, and more with your permission every step of the way";
    downloadPage = "https://github.com/cline/cline";
    homepage = "https://github.com/cline/cline";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
