{
  lib,
  vscode-utils,
  nix-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  mktplcRef = {
    publisher = "yoshi47";
    name = "selection-path-copier";
    version = "1.6.0";
    hash = "sha256-KnV9WariqK3GMjoQARtamxriBkL0Pi9y7+fhfwObCWE=";
  };
  meta = {
    description = "Copy file paths with line numbers, code snippets, and GitHub permalinks in multiple formats";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=yoshi47.selection-path-copier";
    homepage = "https://github.com/yoshi47/selection-path-copier";
    changelog = "https://github.com/yoshi47/selection-path-copier/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
  };
})
