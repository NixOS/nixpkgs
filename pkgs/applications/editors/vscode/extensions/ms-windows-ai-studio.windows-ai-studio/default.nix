{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "windows-ai-studio";
    publisher = "ms-windows-ai-studio";
    version = "1.0.0";
    hash = "sha256-bpq4q/ZEk75NBiwP1VUtTCV2xHed38+CiSKNkT/ClWk=";
  };

  meta = {
    description = "Visual Studio Code extension to help developers and AI engineers build AI apps";
    homepage = "https://github.com/Microsoft/windows-ai-studio";
    license = lib.licenses.unfree;
    maintainers = [ ];
  };
}
