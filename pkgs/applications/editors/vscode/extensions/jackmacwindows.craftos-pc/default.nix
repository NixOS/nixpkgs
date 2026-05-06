{
  vscode-utils,
  craftos-pc,
  lib,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "craftos-pc";
    publisher = "jackmacwindows";
    version = "1.2.3";
    hash = "sha256-QoLMefSmownw9AEem0jx1+BF1bcolHYpiqyPKQNkdiQ=";
  };
  executableConfig =
    lib.genAttrs
      [
        "craftos-pc.executablePath.linux"
        "craftos-pc.executablePath.linux"
        "craftos-pc.executablePath.windows"
      ]
      (_: {
        package = craftos-pc;
      });
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/jackmacwindows.craftos-pc/changelog";
    description = "Visual Studio Code extension for opening a CraftOS-PC window";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=jackmacwindows.craftos-pc";
    homepage = "https://www.craftos-pc.cc/docs/extension";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomodachi94 ];
    platforms = craftos-pc.meta.platforms;
  };
}
