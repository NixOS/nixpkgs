{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "min-theme";
    publisher = "miguelsolorio";
    version = "1.5.0";
    hash = "sha256-DF/9OlWmjmnZNRBs2hk0qEWN38RcgacdVl9e75N8ZMY=";
  };
  meta = {
    description = "Minimal theme for VS Code that comes in dark and light";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=miguelsolorio.min-theme";
    homepage = "https://github.com/miguelsolorio/min-theme";
    license = lib.licenses.mit;
  };
}
