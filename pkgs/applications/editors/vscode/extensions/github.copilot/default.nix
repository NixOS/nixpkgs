{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "github";
    name = "copilot";
    version = "1.322.0";
    hash = "sha256-PekZQeRqpCSSVQe+AA0XLAwC3K0LGtRMbfnN7MxfmGA=";
  };

  meta = {
    description = "GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=GitHub.copilot";
    homepage = "https://github.com/features/copilot";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.Zimmi48 ];
  };
}
