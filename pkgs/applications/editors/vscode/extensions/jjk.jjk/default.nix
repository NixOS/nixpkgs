{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "jjk";
    publisher = "jjk";
    version = "0.11.0";
    hash = "sha256-hEgr8u6p2aI5TwjgC+iNF7M5oU+DLLZcw7M88Ech87w=";
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
