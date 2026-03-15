{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "opencode-v2";
    publisher = "sst-dev";
    version = "0.1.1";
    hash = "sha256-11a8JaishNyy6XkTeh6s36efdt1tSNYclOdkglx8x30=";
  };
  meta = {
    changelog = "https://opencode.ai/changelog/";
    description = "A Visual Studio Code extension that integrates opencode directly into your development workflow with an enhanced chat interface.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=sst-dev.opencode-v2";
    homepage = "https://github.com/anomalyco/opencode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cassis163 ];
  };
}
