{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "debugpy";
    publisher = "ms-python";
    version = "2025.16.0";
    hash = "sha256-QPIDUzzwIfzyicsCwqU2u6hVSjCJMInHhHMBqvL8tYs=";
  };

  meta = {
    description = "Python debugger (debugpy) extension for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.debugpy";
    homepage = "https://github.com/Microsoft/vscode-python-debugger";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.carlthome ];
  };
}
