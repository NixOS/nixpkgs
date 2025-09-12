{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "github";
    name = "copilot";
    version = "1.350.0";
    hash = "sha256-F675MNhjhg0ZP1CepJA1m6Cb5rRcd1vj9tBeNLqjzA0=";
  };

  meta = {
    description = "GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=GitHub.copilot";
    homepage = "https://github.com/features/copilot";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.Zimmi48 ];
  };
}
