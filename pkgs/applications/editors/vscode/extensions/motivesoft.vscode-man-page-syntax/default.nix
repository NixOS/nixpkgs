{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-man-page-syntax";
    publisher = "motivesoft";
    version = "1.1.4";
    hash = "sha256-Hf6UUXShxhFpOG4aaKqHKoyJ0yqFthzNSVW/JZph43c=";
  };

  meta = {
    changelog = "https://github.com/Motivesoft/vscode-man-page-syntax/blob/main/CHANGELOG.md";
    description = "Syntax highlighting support for manpage authoring";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=motivesoft.vscode-man-page-syntax";
    homepage = "https://github.com/Motivesoft/vscode-man-page-syntax";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.iamanaws ];
  };
}
