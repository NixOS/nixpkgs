{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "windows-ai-studio";
    publisher = "ms-windows-ai-studio";
    version = "1.6.10";
    hash = "sha256-ztzf1mrQT6/C89R5DkSNlxSXwyWgRi8uzawXAV7ZhSo=";
  };

  meta = {
    description = "Visual Studio Code extension to help developers and AI engineers build AI apps";
    homepage = "https://github.com/Microsoft/windows-ai-studio";
    license = lib.licenses.unfree;
    maintainers = [ ];
  };
}
