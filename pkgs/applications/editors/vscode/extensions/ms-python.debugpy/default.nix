{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "debugpy";
    publisher = "ms-python";
    version = "2025.14.1";
    hash = "sha256-zmIv93uKBxgyI1cYh9WeF2g8ujm0Z++eoLN01aXaDF8=";
  };

  meta = {
    description = "Python debugger (debugpy) extension for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.debugpy";
    homepage = "https://github.com/Microsoft/vscode-python-debugger";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.carlthome ];
  };
}
