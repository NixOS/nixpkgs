{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "explorer";
    publisher = "vitest";
    version = "1.52.0";
    hash = "sha256-umMYz17CGdqOtRAsGqtLpBElFteK2vkBsnlEnZPd5zc=";
  };
  meta = {
    changelog = "https://github.com/vitest-dev/vscode/releases";
    description = "Vitest extension for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=vitest.explorer";
    homepage = "https://github.com/vitest-dev/vscode";
    license = lib.licenses.mit;
  };
}
