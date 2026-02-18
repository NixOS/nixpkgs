{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "jjk";
    publisher = "jjk";
    version = "0.8.2";
    hash = "sha256-6Fb6HP0vGxuskg+mox4sKutX0nEX4PSmgF49cuJ5vtI=";
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
