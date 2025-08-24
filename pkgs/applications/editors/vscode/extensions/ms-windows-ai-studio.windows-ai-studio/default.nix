{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "windows-ai-studio";
    publisher = "ms-windows-ai-studio";
    version = "0.18.3";
    hash = "sha256-F9anvTj8oNN9TaAWcRvZVTcgREyCqeVLRtnIo7XNHXk=";
  };

  meta = {
    description = "Visual Studio Code extension to help developers and AI engineers build AI apps";
    homepage = "https://github.com/Microsoft/windows-ai-studio";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
  };
}
