{
  lib,
  vscode-utils,
  nix-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  mktplcRef = {
    publisher = "yoshi47";
    name = "selection-path-copier";
    version = "1.5.0";
    hash = "sha256-ip8dsU8B2vghINPSftvfC5OtM0bjIP0V3JAMt5skmdg=";
  };
  meta = {
    description = "Copy file paths with line numbers, code snippets, and GitHub permalinks in multiple formats";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=yoshi47.selection-path-copier";
    homepage = "https://github.com/yoshi47/selection-path-copier";
    changelog = "https://github.com/yoshi47/selection-path-copier/releases/tag/release/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
  };
})
