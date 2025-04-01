{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "nimlang";
    publisher = "nimlang";
    version = "1.6.0";
    hash = "sha256-tMMD1UfmfG+q+qWUpcxfwVSRGO+rpFF7hhWepuFTrdA=";
  };
  meta = {
    description = "Nim language support for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=nimlang.nimlang";
    homepage = "https://github.com/nim-lang/vscode-nim";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}
