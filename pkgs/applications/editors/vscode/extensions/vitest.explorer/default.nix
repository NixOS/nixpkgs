{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "explorer";
    publisher = "vitest";
    version = "1.50.3";
    hash = "sha256-SToca0rF27lF+g09HzgSNcVLy/QNkqKaWLEh98+5mXA=";
  };
  meta = {
    changelog = "https://github.com/vitest-dev/vscode/releases";
    description = "Vitest extension for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=vitest.explorer";
    homepage = "https://github.com/vitest-dev/vscode";
    license = lib.licenses.mit;
  };
}
