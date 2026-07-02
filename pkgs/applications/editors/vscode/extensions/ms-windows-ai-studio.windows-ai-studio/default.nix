{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "windows-ai-studio";
    publisher = "ms-windows-ai-studio";
    version = "1.6.1";
    hash = "sha256-9q3rK/7Q7XiaH9DZN8Yvar/WTdYdEdRXH02WK1tfk5k=";
  };

  meta = {
    description = "Visual Studio Code extension to help developers and AI engineers build AI apps";
    homepage = "https://github.com/Microsoft/windows-ai-studio";
    license = lib.licenses.unfree;
    maintainers = [ ];
  };
}
