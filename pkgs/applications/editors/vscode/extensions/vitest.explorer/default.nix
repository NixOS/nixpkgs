{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "explorer";
    publisher = "vitest";
    version = "1.50.0";
    hash = "sha256-Fl9HtEavM1Cyxf5IMBN7/12s+JGF3MfLRFeut2pEp+s=";
  };
  meta = {
    changelog = "https://github.com/vitest-dev/vscode/releases";
    description = "Vitest extension for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=vitest.explorer";
    homepage = "https://github.com/vitest-dev/vscode";
    license = lib.licenses.mit;
  };
}
