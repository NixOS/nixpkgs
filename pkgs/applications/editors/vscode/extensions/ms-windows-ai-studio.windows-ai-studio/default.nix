{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "windows-ai-studio";
    publisher = "ms-windows-ai-studio";
    version = "0.20.0";
    hash = "sha256-oRbNML3+Ynnv7rQamv03TJphun3nAKVeDtVxRXTkoK0=";
  };

  meta = {
    description = "Visual Studio Code extension to help developers and AI engineers build AI apps";
    homepage = "https://github.com/Microsoft/windows-ai-studio";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
  };
}
