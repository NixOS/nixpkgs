{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "glsl-literal";
    publisher = "boyswan";
    version = "1.0.6";
    hash = "sha256-xprVNva0UOZBiCxxhnd71L+nLbtCbYfy4v6z8x685ck=";
  };

  meta = {
    description = "Syntax highlighting for GLSL inside of JavaScript tagged template strings";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=boyswan.glsl-literal";
    homepage = "https://github.com/boyswan/vscode-glsl-literal";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.frontear ];
  };
}
