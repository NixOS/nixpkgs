{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  mktplcRef = {
    publisher = "yltx";
    name = "vscode-luogu";
    version = "4.13.0";
    hash = "sha256-tNEsG6Lp0V9+qZSLPuwpEaRRuEQQmkjjS8CFgrergQ4=";
  };
  meta = {
    description = "Solve Luogu Problems in VSCode";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=yltx.vscode-luogu";
    homepage = "https://github.com/yltx/vscode-luogu";
    changelog = "https://github.com/yltx/vscode-luogu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Blind-Guess-Senior ];
  };
})
