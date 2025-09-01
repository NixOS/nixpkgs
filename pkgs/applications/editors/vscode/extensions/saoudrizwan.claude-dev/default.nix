{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "claude-dev";
    publisher = "saoudrizwan";
    version = "3.25.3";
    hash = "sha256-9a4QvVZ0vWR0zWgYAZN0zv95J2VNBbFQHc8mAH6H680=";
  };

  meta = {
    description = "VSCode extension providing an autonomous coding agent right in your IDE, capable of creating/editing files, executing commands, using the browser, and more with your permission every step of the way";
    downloadPage = "https://github.com/cline/cline";
    homepage = "https://github.com/cline/cline";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
