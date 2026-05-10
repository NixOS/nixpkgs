{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "opencode";
    publisher = "sst-dev";
    version = "0.0.13";
    hash = "sha256-6adXUaoh/OP5yYItH3GAQ7GpupfmTGaxkKP6hYUMYNQ=";
  };
  meta = {
    changelog = "https://opencode.ai/changelog/";
    description = "A Visual Studio Code extension that integrates opencode directly into your development workflow.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=sst-dev.opencode";
    homepage = "https://github.com/anomalyco/opencode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cassis163 ];
  };
}
