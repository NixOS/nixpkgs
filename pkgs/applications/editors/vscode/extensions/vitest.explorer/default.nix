{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "explorer";
    publisher = "vitest";
    version = "1.44.1";
    hash = "sha256-Ac6v4QwWpmZ8unjW3AnbPGe+JBQTUz2+v7X2/BRckcw=";
  };
  meta = {
    changelog = "https://github.com/vitest-dev/vscode/releases";
    description = "Vitest extension for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=vitest.explorer";
    homepage = "https://github.com/vitest-dev/vscode";
    license = lib.licenses.mit;
  };
}
