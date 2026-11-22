{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  mktplcRef = {
    name = "claude-dev";
    publisher = "saoudrizwan";
    version = "4.1.26";
    hash = "sha256-2OpMNQUFLEjnx6VVjnITpTgntrodp+VlE8h9iW31HE0=";
  };

  meta = {
    description = "Autonomous coding agent for VS Code";
    longDescription = ''
      Creates and edits files, runs commands, and uses the browser, asking
      permission at each step.
    '';
    homepage = "https://cline.bot";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev";
    changelog = "https://github.com/cline/cline/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ iamanaws ];
  };
})
