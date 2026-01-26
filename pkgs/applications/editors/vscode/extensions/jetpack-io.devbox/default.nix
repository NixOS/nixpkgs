{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "devbox";
    publisher = "jetpack-io";
    version = "0.1.6";
    hash = "sha256-cPlMZzF3UNVJCz16TNPoiGknukEWXNNXnjZVMyp/Dz8=";
  };

  meta = {
    description = "Official VSCode extension for devbox open source project by jetify.com";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=jetpack-io.devbox";
    homepage = "https://github.com/jetify-com/devbox#readme";
    changelog = "https://marketplace.visualstudio.com/items/jetpack-io.devbox/changelog";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kuzushicat ];
  };
}
