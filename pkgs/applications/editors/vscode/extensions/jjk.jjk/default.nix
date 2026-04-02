{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "jjk";
    publisher = "jjk";
    version = "0.9.3";
    hash = "sha256-wkHMZTLi3dDV6JQdfJ4hI5uwGAlCmKwg+v8Z9RMU1wU=";
  };
  meta = {
    changelog = "https://github.com/keanemind/jjk/releases";
    description = "Visual Studio Code extension for the Jujutsu (jj) version control system";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=jjk.jjk";
    homepage = "https://github.com/keanemind/jjk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilai-deutel ];
  };
}
